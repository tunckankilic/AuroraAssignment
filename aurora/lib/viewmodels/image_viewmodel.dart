import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;
import '../services/image_service.dart';
import '../models/image_model.dart';

// Görsel + Renk pair
class ImageColorPair {
  final String url;
  final Color color;
  
  ImageColorPair(this.url, this.color);
}

class ImageViewModel extends ChangeNotifier {
  final ImageService _imageService = ImageService();

  String? _imageUrl;
  Color _backgroundColor = const Color(0xFF1A1A1A);
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPrefetching = false;

  // Queue sistemi - her zaman 2 adım ileri hazır
  final List<ImageColorPair> _imageQueue = [];
  static const int _lookahead = 2; // Her zaman sonraki 2 görsel hazır

  // Getters
  String? get imageUrl => _imageUrl;
  Color get backgroundColor => _backgroundColor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get queueLength => _imageQueue.length;

  // Uygulama başladığında queue'yu doldur
  ImageViewModel() {
    _initializeQueue();
  }

  // İlk görseli hızlıca göster, sonra sonrakini hazırla
  Future<void> _initializeQueue() async {
    _isLoading = true;
    notifyListeners();

    // İlk görseli hemen yükle ve göster
    final firstPair = await _loadImageWithColor();
    if (firstPair != null) {
      _imageUrl = firstPair.url;
      _backgroundColor = firstPair.color;
      _isLoading = false;
      notifyListeners();
      
      // Arka planda sonraki 2'yi hazırla
      debugPrint('First image shown, prefetching next 2...');
      unawaited(_fillQueue());
    } else {
      _errorMessage = 'İlk görsel yüklenemedi';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı "Another" butonuna bastığında çağrılır
  Future<void> fetchImage() async {
    if (_isLoading || _imageQueue.isEmpty) return;
    
    // Queue'dan anında al - görsel VE renk hazır! ⚡
    _showNextImage();
    
    // Arka planda queue'yu tekrar doldur
    unawaited(_fillQueue());
  }
  
  // Helper function - await etmeden arka planda çalıştır
  void unawaited(Future<void> future) {
    future.catchError((error) {
      debugPrint('Background task error: $error');
    });
  }

  // Queue'yu doldur - her zaman lookahead kadar hazır tut
  Future<void> _fillQueue() async {
    if (_isPrefetching) return;
    _isPrefetching = true;

    try {
      // Eksik kadarını doldur (max lookahead)
      while (_imageQueue.length < _lookahead) {
        final pair = await _loadImageWithColor();
        if (pair != null) {
          _imageQueue.add(pair);
          final next = _imageQueue.length + 1;
          debugPrint('Prefetched: Next +$next ready (Queue: ${_imageQueue.length}/$_lookahead)');
        } else {
          // Yükleme başarısız, dur
          break;
        }
      }
    } finally {
      _isPrefetching = false;
    }
  }

  // Queue'dan anında göster - görsel VE renk hazır!
  void _showNextImage() {
    if (_imageQueue.isEmpty) {
      debugPrint('Queue empty! Loading...');
      _isLoading = true;
      notifyListeners();
      return;
    }
    
    // Queue'dan çıkar
    final pair = _imageQueue.removeAt(0);
    
    // ANINDA değiştir - 0ms! Kitap sayfası gibi! 📖
    _imageUrl = pair.url;
    _backgroundColor = pair.color;
    _errorMessage = null;
    _isLoading = false;
    
    // Tek notify - her şey hazır!
    notifyListeners();
    
    // Kalan ne kadar?
    final remaining = _imageQueue.length;
    debugPrint('Page turned! Remaining: $remaining, Total ready: ${remaining + 1}');
  }

  // Görsel + Renk yükle (tek seferde!)
  Future<ImageColorPair?> _loadImageWithColor() async {
    int retryCount = 0;
    const maxRetries = 3; // Daha az retry - queue var

    while (retryCount < maxRetries) {
      try {
        // 1. API'den URL al
        final ImageModel imageModel = await _imageService.fetchRandomImage();
        
        // 2. Görseli kontrol et
        final isValid = await _validateImageUrl(imageModel.url);
        if (!isValid) {
          retryCount++;
          continue;
        }
        
        // 3. Cache'e al
        await _precacheImageToCache(imageModel.url);
        
        // 4. Rengi ÇIK (önceden!)
        final color = await _extractColorSync(imageModel.url);
        
        // 5. Pair oluştur - hazır!
        return ImageColorPair(imageModel.url, color);
        
      } catch (e) {
        retryCount++;
        debugPrint('Load error ($retryCount/$maxRetries): $e');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    
    return null; // Başarısız
  }

  // Görselin erişilebilir olup olmadığını kontrol et
  Future<bool> _validateImageUrl(String url) async {
    try {
      // HEAD request ile görsel varlığını kontrol et
      final response = await http.head(
        Uri.parse(url),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Image validation timeout: $url');
          return http.Response('', 408);
        },
      );
      
      // 200-299 arası status code başarılıdır
      final isValid = response.statusCode >= 200 && response.statusCode < 300;
      if (!isValid) {
        debugPrint('Image validation failed: ${response.statusCode} - $url');
      }
      return isValid;
    } catch (e) {
      debugPrint('Image validation error: $e');
      return false;
    }
  }

  // Renk çıkarma (senkron - await ile) - Queue için
  Future<Color> _extractColorSync(String url) async {
    try {
      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(url),
        maximumColorCount: 5,
        timeout: const Duration(seconds: 3),
      );

      // Dominant renk önceliği
      if (palette.dominantColor != null) {
        return palette.dominantColor!.color.withOpacity(0.8);
      } else if (palette.vibrantColor != null) {
        return palette.vibrantColor!.color.withOpacity(0.8);
      } else if (palette.darkMutedColor != null) {
        return palette.darkMutedColor!.color.withOpacity(0.8);
      }
    } catch (e) {
      debugPrint('Color extraction failed: ${e.toString().split('\n').first}');
    }
    
    // Fallback
    return const Color(0xFF1A1A1A);
  }

  // Görseli CachedNetworkImage cache'ine al
  Future<void> _precacheImageToCache(String url) async {
    try {
      final imageProvider = CachedNetworkImageProvider(url);
      
      // ImageStreamCompleter kullanarak görseli cache'e al
      final completer = Completer<void>();
      final stream = imageProvider.resolve(const ImageConfiguration());
      
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          // Görsel başarıyla yüklendi
          debugPrint('Image downloaded to cache');
          stream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          // Hata oluştu ama devam et
          debugPrint('Precache error: $exception');
          stream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
      
      stream.addListener(listener);
      
      // 10 saniye timeout
      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Precache timeout (but continuing)');
          stream.removeListener(listener);
        },
      );
    } catch (e) {
      // Cache'leme başarısız olsa bile devam et
      debugPrint('Precache warning: ${e.toString().split('\n').first}');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

