import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:hadi_portfolio/view/portfolio_screen/portfolio_screen.dart';
import 'package:hadi_portfolio/view/splash_screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen(), transition: Transition.fadeIn),
        GetPage(name: '/home',   page: () => const HomeScreen(), transition: Transition.fadeIn),
      ],
    );
  }
}
