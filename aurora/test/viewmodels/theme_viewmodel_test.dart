import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora/viewmodels/theme_viewmodel.dart';

void main() {
  group('ThemeViewModel Tests', () {
    late ThemeViewModel viewModel;

    setUp(() {
      viewModel = ThemeViewModel();
    });

    test('Initial theme should be dark', () {
      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.isDarkMode, true);
    });

    test('Toggle should switch theme', () {
      // Initial: dark
      expect(viewModel.isDarkMode, true);

      // Toggle to light
      viewModel.toggleTheme();
      expect(viewModel.themeMode, ThemeMode.light);
      expect(viewModel.isDarkMode, false);

      // Toggle back to dark
      viewModel.toggleTheme();
      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.isDarkMode, true);
    });

    test('setThemeMode should set theme correctly', () {
      viewModel.setThemeMode(ThemeMode.light);
      expect(viewModel.themeMode, ThemeMode.light);

      viewModel.setThemeMode(ThemeMode.dark);
      expect(viewModel.themeMode, ThemeMode.dark);

      viewModel.setThemeMode(ThemeMode.system);
      expect(viewModel.themeMode, ThemeMode.system);
    });
  });
}

