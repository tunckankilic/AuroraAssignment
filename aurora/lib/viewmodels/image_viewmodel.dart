import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';
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

  // Queue sistemi - basit ve etkili (2 image buffer)
  final List<ImageColorPair> _imageQueue = [];
  static const int _lookahead = 2; // 2 instant transition için yeterli

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
      _errorMessage = 'First image failed to load';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı "Another" butonuna bastığında çağrılır
  Future<void> fetchImage() async {
    if (_isLoading) return;
    
    // Queue boş mu? Loading göster ve bekle
    if (_imageQueue.isEmpty) {
      _isLoading = true;
      notifyListeners();
      
      await _fillQueue();
      
      if (_imageQueue.isEmpty) {
        _errorMessage = 'Failed to load image. Please try again.';
        _isLoading = false;
        notifyListeners();
        return;
      }
    }
    
    // Queue'dan anında al ve göster ⚡
    _showNextImage();
    
    // Arka planda queue'yu doldur (non-blocking)
    unawaited(_fillQueue());
  }
  
  // Helper function - await etmeden arka planda çalıştır
  void unawaited(Future<void> future) {
    future.catchError((error) {
      debugPrint('Background task error: $error');
    });
  }

  // Queue'yu doldur - Basit sequential loading
  Future<void> _fillQueue() async {
    if (_isPrefetching) return;
    _isPrefetching = true;

    try {
      while (_imageQueue.length < _lookahead) {
        final pair = await _loadImageWithColor();
        
        if (pair != null) {
          _imageQueue.add(pair);
        } else {
          // Yükleme başarısız, dur
          break;
        }
      }
    } finally {
      _isPrefetching = false;
    }
  }

  // Queue'dan anında göster
  void _showNextImage() {
    if (_imageQueue.isEmpty) return;
    
    final pair = _imageQueue.removeAt(0);
    
    _imageUrl = pair.url;
    _backgroundColor = pair.color;
    _errorMessage = null;
    _isLoading = false;
    
    notifyListeners();
  }

  // Görsel + Renk yükle
  Future<ImageColorPair?> _loadImageWithColor() async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final ImageModel imageModel = await _imageService.fetchRandomImage();
        
        // Cache'e al
        await _precacheImageToCache(imageModel.url);
        
        // Rengi çıkar
        final color = await _extractColorSync(imageModel.url);
        
        return ImageColorPair(imageModel.url, color);
        
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          debugPrint('Failed to load image after $maxRetries attempts');
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    
    return null;
  }


  // Renk çıkarma
  Future<Color> _extractColorSync(String url) async {
    try {
      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(url),
        maximumColorCount: 5,
        timeout: const Duration(seconds: 2),
      );

      if (palette.dominantColor != null) {
        return palette.dominantColor!.color.withOpacity(0.8);
      } else if (palette.vibrantColor != null) {
        return palette.vibrantColor!.color.withOpacity(0.8);
      } else if (palette.darkMutedColor != null) {
        return palette.darkMutedColor!.color.withOpacity(0.8);
      }
    } catch (e) {
      // Fallback on error
    }
    
    return const Color(0xFF1A1A1A);
  }

  // Görseli cache'e al
  Future<void> _precacheImageToCache(String url) async {
    try {
      final imageProvider = CachedNetworkImageProvider(url);
      final completer = Completer<void>();
      final stream = imageProvider.resolve(const ImageConfiguration());
      
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          stream.removeListener(listener);
          if (!completer.isCompleted) completer.complete();
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          stream.removeListener(listener);
          if (!completer.isCompleted) completer.complete();
        },
      );
      
      stream.addListener(listener);
      
      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => stream.removeListener(listener),
      );
    } catch (e) {
      // Continue on error
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

