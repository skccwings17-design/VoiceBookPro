import 'package:flutter/material.dart';

class AppTheme {
  // Soft Pastel Palette
  static const Color primary = Color(0xFF9BA4ED); // Soft Indigo
  static const Color secondary = Color(0xFFF8BBD0); // Soft Pink
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF2D3436);
  static const Color textMuted = Color(0xFF636E72);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        background: background,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textMain,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: TextStyle(
          color: textMain,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 14,
        ),
      ),
    );
  }
}
