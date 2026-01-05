import 'package:flutter/material.dart';

class AnotherButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const AnotherButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Load new image',
      enabled: !isLoading && onPressed != null,
      child: AnimatedScale(
        scale: isLoading ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: isLoading ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              disabledBackgroundColor: const Color(0xFF3A3A3A),
              disabledForegroundColor: Colors.white38,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              minimumSize: const Size(160, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: isLoading ? 2 : 6,
              shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    )
                  : const Text(
                      'Another',
                      key: ValueKey('text'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

