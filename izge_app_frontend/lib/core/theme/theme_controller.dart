import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:izge_app_frontend/app/app.dart' as izge_app_import;

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
    
    // Force rebuild all active screens to apply static AppColors instantly
    try {
      // Use the global navigatorKey from app.dart to get the root context
      // Note: Make sure to import app.dart at the top
      final context = izge_app_import.navigatorKey.currentContext;
      if (context != null) {
        void rebuild(Element el) {
          el.markNeedsBuild();
          el.visitChildren(rebuild);
        }
        (context as Element).visitChildren(rebuild);
      }
    } catch (e) {
      // Fallback
    }
    
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
