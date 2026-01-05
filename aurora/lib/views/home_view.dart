import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/image_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import 'widgets/image_card.dart';
import 'widgets/another_button.dart';
import 'widgets/shimmer_placeholder.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImageViewModel>(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.75 > 400 ? 400.0 : size.width * 0.75;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Blurred Background
          _buildBlurredBackground(viewModel),
          
          // Layer 2: Content
          SafeArea(
            child: _buildContent(context, viewModel, imageSize),
          ),
          
          // Layer 3: Theme Toggle Button (must be in Stack directly)
          _buildThemeToggle(themeViewModel),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(ThemeViewModel themeViewModel) {
    return Positioned(
      top: 16,
      right: 16,
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: themeViewModel.toggleTheme,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    themeViewModel.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    key: ValueKey(themeViewModel.isDarkMode),
                    color: themeViewModel.isDarkMode
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFFB8860B),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlurredBackground(ImageViewModel viewModel) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200), // Çok daha uzun ve belirgin!
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Fade + Scale animasyonu - çok daha belirgin!
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.05, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
      child: viewModel.imageUrl != null
          ? Container(
              key: ValueKey(viewModel.imageUrl),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(viewModel.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  color: viewModel.backgroundColor.withOpacity(0.3),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              color: viewModel.backgroundColor,
            ),
    );
  }

  Widget _buildContent(BuildContext context, ImageViewModel viewModel, double imageSize) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // App Title
            Text(
              'Aurora',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Discover & Inspire',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFD4AF37),
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Image or Shimmer - Belirgin ve smooth transition!
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1400), // Çok daha uzun ve dramatik!
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Fade + Scale + Slide kombinasyonu - süper belirgin!
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
                        ),
                      ),
                      child: child,
                    ),
                  ),
                );
              },
              child: viewModel.isLoading && viewModel.imageUrl == null
                  ? ShimmerPlaceholder(
                      key: const ValueKey('shimmer'),
                      size: imageSize,
                    )
                  : viewModel.imageUrl != null
                      ? ImageCard(
                          key: ValueKey(viewModel.imageUrl),
                          imageUrl: viewModel.imageUrl!,
                          size: imageSize,
                        )
                      : Container(
                          key: const ValueKey('empty'),
                          width: imageSize,
                          height: imageSize,
                        ),
            ),
            
            const SizedBox(height: 60),
            
            // Error Message
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Another Button
            AnotherButton(
              onPressed: viewModel.fetchImage,
              isLoading: viewModel.isLoading && viewModel.imageUrl == null,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

