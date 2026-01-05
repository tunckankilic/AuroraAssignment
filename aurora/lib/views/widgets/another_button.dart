import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnotherButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const AnotherButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<AnotherButton> createState() => _AnotherButtonState();
}

class _AnotherButtonState extends State<AnotherButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() => _isPressed = true);
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.94 : (widget.isLoading ? 0.97 : 1.0);
    
    return Semantics(
      button: true,
      label: 'Load new image',
      enabled: !widget.isLoading && widget.onPressed != null,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: scale),
          duration: Duration(milliseconds: _isPressed ? 100 : 200),
          curve: _isPressed ? Curves.easeOut : Curves.easeOutCubic,
          builder: (context, animatedScale, child) {
            return Transform.scale(
              scale: animatedScale,
              child: AnimatedOpacity(
                opacity: widget.isLoading ? 0.8 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
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
                    elevation: _isPressed ? 1 : (widget.isLoading ? 2 : 6),
                    shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: widget.isLoading
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
            );
          },
        ),
      ),
    );
  }
}

