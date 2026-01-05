import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/image_viewmodel.dart';
import 'widgets/image_card.dart';
import 'widgets/another_button.dart';
import 'widgets/shimmer_placeholder.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImageViewModel>(context);
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.75 > 400 ? 400.0 : size.width * 0.75;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Blurred Background
          _buildBlurredBackground(viewModel),
          
          // Layer 2 & 3: Content
          SafeArea(
            child: _buildContent(context, viewModel, imageSize),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground(ImageViewModel viewModel) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
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
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  color: viewModel.backgroundColor.withOpacity(0.3),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
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
            
            // Image or Shimmer
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: child,
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
              isLoading: viewModel.isLoading,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

