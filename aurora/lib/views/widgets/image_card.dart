import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shimmer_placeholder.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Random image',
      child: Hero(
        tag: 'image_$imageUrl',
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 800),
              fadeOutDuration: const Duration(milliseconds: 400),
              fadeInCurve: Curves.easeInOut,
              fadeOutCurve: Curves.easeInOut,
              placeholder: (context, url) => ShimmerPlaceholder(size: size),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF1A1A1A),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: size * 0.2,
                      color: Colors.white24,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Görsel Yüklenemedi',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: size * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

