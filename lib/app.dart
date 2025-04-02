import 'package:flutter/material.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'screens/splash_screen.dart';

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mileage Calculator',
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}