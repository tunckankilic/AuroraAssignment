import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/image_viewmodel.dart';
import 'views/home_view.dart';
import 'services/navigation_service.dart';

void main() {
  runApp(const AuroraApp());
}

class AuroraApp extends StatelessWidget {
  const AuroraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Aurora Image Viewer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Varsayılan olarak dark mode
        navigatorKey: NavigationService.navigatorKey,
        home: const HomeView(),
      ),
    );
  }
}
