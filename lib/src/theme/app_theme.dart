import 'package:flutter/material.dart';

class AppTheme {
  
  static final ColorScheme _appColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF550D3D),
    onPrimary: Colors.white,
    secondary: const Color(0xFF1C365D),
    onSecondary: Colors.white,
    tertiary: const Color(0xFFF4A7B9),
    onTertiary: const Color(0xFF550D3D),
    secondaryContainer: const Color(0xFF82C8E5), // Hellblau
    onSecondaryContainer: const Color(0xFF1C365D),
    surface: Colors.white,
    onSurface: const Color(0xFF1C365D),
    error: const Color(0xFFB00020),
    onError: Colors.white,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _appColorScheme,
      scaffoldBackgroundColor: _appColorScheme.surface,
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFF550D3D), fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Color(0xFF550D3D), fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Color(0xFF550D3D), fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFF1C365D)),
        bodyMedium: TextStyle(color: Color(0xFF1C365D)),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: _appColorScheme.primary,
        foregroundColor: _appColorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _appColorScheme.primary,
          foregroundColor: _appColorScheme.onPrimary,
        ),
      ),
    );
  }
}