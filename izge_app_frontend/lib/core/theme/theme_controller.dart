import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._();
  
  static final ThemeController instance = ThemeController._();

  ThemeMode _themeMode = ThemeMode.dark; // Varsayılan karanlık

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _updateAppColors();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _updateAppColors();
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
  
  void _updateAppColors() {
    if (_themeMode == ThemeMode.light) {
      AppColors.setLightMode();
    } else {
      AppColors.setDarkMode();
    }
  }
}
