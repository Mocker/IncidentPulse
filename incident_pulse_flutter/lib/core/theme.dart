import 'package:flutter/material.dart';

class IncidentTheme {
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceBorder = Color(0xFF1E293B);

  // Status colors
  static const Color statusOperational = Color(0xFF10B981); // Emerald
  static const Color statusDegraded = Color(0xFFF59E0B);    // Amber
  static const Color statusCritical = Color(0xFFEF4444);    // Crimson
  static const Color aiAccent = Color(0xFF8B5CF6);          // Violet / AI Diagnostic Accent

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: aiAccent,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: surfaceBorder, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: aiAccent,
        surface: surface,
      ),
    );
  }
}
