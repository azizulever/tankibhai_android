import 'package:flutter/material.dart';

// Define our colors
const Color primaryColor = Color(0xFF0045ED); // Blue
const Color backgroundColor = Color(0xFFF8FAFC); // Light Gray

final appTheme = ThemeData(
  useMaterial3: true,
  
  // Color Scheme
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    background: backgroundColor,
    surface: backgroundColor,
  ),
  
  // General Theme Properties
  scaffoldBackgroundColor: backgroundColor,
  
  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),
  
  // Card Theme
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // Button Themes
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  
  // Segmented Button Theme
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        return states.contains(MaterialState.selected) 
            ? primaryColor 
            : Colors.white;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        return states.contains(MaterialState.selected) 
            ? Colors.white 
            : primaryColor;
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
  ),
  
  // Divider Theme
  dividerTheme: DividerThemeData(
    color: backgroundColor.darker(10),
    thickness: 1,
  ),
);

// Extension to darken colors slightly
extension ColorExtension on Color {
  Color darker(int percent) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }
}