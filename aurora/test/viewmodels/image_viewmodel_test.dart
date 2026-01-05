import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora/viewmodels/image_viewmodel.dart';

void main() {
  group('ImageViewModel Tests', () {
    late ImageViewModel viewModel;

    setUp(() {
      viewModel = ImageViewModel();
    });

    test('Initial state should be loading', () {
      expect(viewModel.isLoading, true);
      expect(viewModel.imageUrl, null);
    });

    test('Background color should have default value', () {
      expect(viewModel.backgroundColor, const Color(0xFF1A1A1A));
    });

    test('Error message should be null initially', () {
      expect(viewModel.errorMessage, null);
    });

    test('Queue length getter should work', () {
      expect(viewModel.queueLength, greaterThanOrEqualTo(0));
    });

    test('fetchImage should not throw when called multiple times', () {
      expect(() => viewModel.fetchImage(), returnsNormally);
      expect(() => viewModel.fetchImage(), returnsNormally);
    });
  });
}

