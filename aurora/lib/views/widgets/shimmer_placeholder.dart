import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double size;

  const ShimmerPlaceholder({
    super.key,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A1A),
      highlightColor: const Color(0xFFD4AF37).withOpacity(0.6), // Daha belirgin!
      period: const Duration(milliseconds: 1200), // Daha hızlı pulse - daha belirgin!
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: size * 0.3,
            color: const Color(0xFFD4AF37).withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

