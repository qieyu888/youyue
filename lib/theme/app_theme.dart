import 'package:flutter/material.dart';

class AppColors {
  static const Color bg = Color(0xFFF4F7F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF7AB2D3);
  static const Color secondary = Color(0xFFFFB6B9);
  static const Color accent = Color(0xFFB5EAD7);
  static const Color textColor = Color(0xFF2D3436);
  static const Color subtext = Color(0xFF8395A7);
  static const Color divider = Color(0xFFF0F0F0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'PingFang SC',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textColor),
        titleTextStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
