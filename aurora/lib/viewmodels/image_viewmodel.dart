import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';
import '../services/image_service.dart';
import '../services/navigation_service.dart';
import '../models/image_model.dart';

class ImageViewModel extends ChangeNotifier {
  final ImageService _imageService = ImageService();

  String? _imageUrl;
  String? _nextImageUrl; // Önbelleğe alınan sonraki görsel
  Color _backgroundColor = const Color(0xFF1A1A1A);
  bool _isLoading = false;
  bool _isTransitioning = false;
  String? _errorMessage;

  // Getters
  String? get imageUrl => _imageUrl;
  String? get nextImageUrl => _nextImageUrl;
  Color get backgroundColor => _backgroundColor;
  bool get isLoading => _isLoading;
  bool get isTransitioning => _isTransitioning;
  String? get errorMessage => _errorMessage;

  // Uygulama başladığında ilk görseli otomatik yükle
  ImageViewModel() {
    fetchImage();
  }

  Future<void> fetchImage() async {
    if (_isLoading) return; // Zaten yükleme varsa tekrar başlatma
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final ImageModel imageModel = await _imageService.fetchRandomImage();
        
        // Görseli önce arka planda yükle ve doğrula
        final isValid = await _precacheImage(imageModel.url);
        
        if (!isValid) {
          retryCount++;
          if (retryCount < maxRetries) {
            debugPrint('Invalid image, retrying... ($retryCount/$maxRetries)');
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
        }
        
        // Geçiş animasyonu başlat
        _isTransitioning = true;
        notifyListeners();
        
        // Kısa bir gecikme ile smooth geçiş
        await Future.delayed(const Duration(milliseconds: 150));
        
        _imageUrl = imageModel.url;
        _errorMessage = null;
        
        // Dominant rengi çıkar (arka planda)
        _extractDominantColor(imageModel.url);
        
        _isLoading = false;
        _isTransitioning = false;
        notifyListeners();
        
        return; // Başarılı, döngüden çık
        
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          _errorMessage = 'Görsel yüklenemedi. Lütfen tekrar deneyin.';
          _isLoading = false;
          _isTransitioning = false;
          notifyListeners();
          return;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  // Görseli önce cache'e al ve geçerliliğini kontrol et
  Future<bool> _precacheImage(String url) async {
    try {
      final imageProvider = CachedNetworkImageProvider(url);
      
      // Görseli önbelleğe al
      await precacheImage(
        imageProvider, 
        NavigationService.navigatorKey.currentContext!,
        onError: (exception, stackTrace) {
          debugPrint('Precache error: $exception');
        },
      );
      
      // Başarılı bir şekilde yüklendiyse true döndür
      return true;
    } catch (e) {
      debugPrint('Precache failed: $e');
      return false;
    }
  }

  Future<void> _extractDominantColor(String url) async {
    try {
      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(url),
        maximumColorCount: 10,
        timeout: const Duration(seconds: 3),
      );

      // Önce dominant rengi dene, yoksa vibrant, yoksa varsayılan
      Color newColor;
      if (palette.dominantColor != null) {
        newColor = palette.dominantColor!.color.withOpacity(0.8);
      } else if (palette.vibrantColor != null) {
        newColor = palette.vibrantColor!.color.withOpacity(0.8);
      } else if (palette.darkMutedColor != null) {
        newColor = palette.darkMutedColor!.color.withOpacity(0.8);
      } else {
        newColor = const Color(0xFF1A1A1A);
      }
      
      // Renk değişimini smooth yap
      _backgroundColor = newColor;
      notifyListeners();
    } catch (e) {
      // Use default color if color extraction fails
      debugPrint('Color extraction error: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

