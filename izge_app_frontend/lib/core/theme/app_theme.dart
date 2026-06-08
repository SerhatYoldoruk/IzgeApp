import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../accessibility/accessibility_controller.dart';

class AppTheme {
  static ThemeData dark() {
    final baseTheme = ThemeData.dark();
    final isDyslexia = AccessibilityController.instance.isDyslexiaFontEnabled;
    final isHighContrast = AccessibilityController.instance.isHighContrastEnabled;

    final primary = isHighContrast ? const Color(0xFFFFFF00) : AppColors.accent; // Yellow
    final background = isHighContrast ? const Color(0xFF000000) : AppColors.background;
    final surface = isHighContrast ? const Color(0xFF000000) : AppColors.surface;
    final textPrimary = isHighContrast ? const Color(0xFFFFFFFF) : AppColors.textPrimary;
    final border = isHighContrast ? const Color(0xFFFFFF00) : AppColors.border;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.black,
        surface: surface,
        onSurface: textPrimary,
        outlineVariant: border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: isHighContrast ? RoundedRectangleBorder(side: BorderSide(color: border, width: 2)) : null,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: isHighContrast ? 2 : 1),
      textTheme: isDyslexia 
          ? GoogleFonts.lexendTextTheme(baseTheme.textTheme)
          : GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: isHighContrast ? Colors.white54 : AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
          side: isHighContrast ? BorderSide(color: primary, width: 2) : null,
        ),
      ),
    );
  }

  static ThemeData light() {
    final baseTheme = ThemeData.light();
    final isDyslexia = AccessibilityController.instance.isDyslexiaFontEnabled;
    final isHighContrast = AccessibilityController.instance.isHighContrastEnabled;

    final primary = isHighContrast ? const Color(0xFF0000FF) : AppColors.accent; // Deep Blue
    final background = isHighContrast ? const Color(0xFFFFFFFF) : AppColors.background;
    final surface = isHighContrast ? const Color(0xFFFFFFFF) : AppColors.surface;
    final textPrimary = isHighContrast ? const Color(0xFF000000) : AppColors.textPrimary;
    final border = isHighContrast ? const Color(0xFF000000) : AppColors.border;

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        outlineVariant: border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: isHighContrast ? RoundedRectangleBorder(side: BorderSide(color: border, width: 2)) : null,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: isHighContrast ? 2 : 1),
      textTheme: isDyslexia 
          ? GoogleFonts.lexendTextTheme(baseTheme.textTheme)
          : GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: isHighContrast ? Colors.black54 : AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          side: isHighContrast ? BorderSide(color: border, width: 2) : null,
        ),
      ),
    );
  }
}
