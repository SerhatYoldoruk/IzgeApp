import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    final baseTheme = ThemeData.dark();

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: AppColors.accentOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outlineVariant: AppColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  static ThemeData light() {
    final baseTheme = ThemeData.light();

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.accentOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outlineVariant: AppColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
