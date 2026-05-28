import 'package:flutter/material.dart';

class AppColors {
  static Color background = const Color(0xFF131313);
  static Color surface = const Color(0xFF1F2020);
  static Color surfaceElevated = const Color(0xFF1B1C1C);
  static Color accent = const Color(0xFF7ADC75);
  static Color accentDark = const Color(0xFF1A8025);
  static Color primary = const Color(0xFF1A8025);
  static Color accentOnPrimary = const Color(0xFF003908);
  static Color textPrimary = const Color(0xFFE5E2E1);
  static Color textSecondary = const Color(0xFFBECAB8);
  static Color border = const Color(0xFF3F4A3C);
  static Color fieldBackground = const Color(0xFF2A2A2A);
  static Color fieldText = const Color(0xFFE5E2E1);
  static Color fieldHint = const Color(0xFF8A8A8A);
  static Color positive = const Color(0xFF43A047);
  static Color error = const Color(0xFFE57373);

  static void setLightMode() {
    background = const Color(0xFFFFFFFF);
    surface = const Color(0xFFF8F9FA);
    surfaceElevated = const Color(0xFFE9ECEF);
    accent = const Color(0xFF1A8025); // Darker green for contrast
    accentDark = const Color(0xFF003908);
    accentOnPrimary = const Color(0xFFD3FFC8);
    textPrimary = const Color(0xFF212529);
    textSecondary = const Color(0xFF6C757D);
    border = const Color(0xFFDEE2E6);
    fieldBackground = const Color(0xFFF1F3F5);
    fieldText = const Color(0xFF212529);
    fieldHint = const Color(0xFF868E96);
    positive = const Color(0xFF2E7D32);
    error = const Color(0xFFD32F2F);
    primary = const Color(0xFF1A8025);
  }

  static void setDarkMode() {
    background = const Color(0xFF131313);
    surface = const Color(0xFF1F2020);
    surfaceElevated = const Color(0xFF1B1C1C);
    accent = const Color(0xFF7ADC75);
    accentDark = const Color(0xFF1A8025);
    accentOnPrimary = const Color(0xFF003908);
    textPrimary = const Color(0xFFE5E2E1);
    textSecondary = const Color(0xFFBECAB8);
    border = const Color(0xFF3F4A3C);
    fieldBackground = const Color(0xFF2A2A2A);
    fieldText = const Color(0xFFE5E2E1);
    fieldHint = const Color(0xFF8A8A8A);
    positive = const Color(0xFF43A047);
    error = const Color(0xFFE57373);
    primary = const Color(0xFF1A8025);
  }
}
