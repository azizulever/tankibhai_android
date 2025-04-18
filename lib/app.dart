import 'package:flutter/material.dart';
import 'package:mileage_calculator/screens/splash_screen.dart';
import 'package:mileage_calculator/utils/theme.dart';

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TankiBhai',
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}