import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:izge_app_frontend/app/app.dart' as izge_app_import;

class AccessibilityController extends ChangeNotifier {
  AccessibilityController._();

  static final AccessibilityController instance = AccessibilityController._();

  bool _isDyslexiaFontEnabled = false;
  bool _isHighContrastEnabled = false;
  double _textScaleFactor = 1.0;

  bool get isDyslexiaFontEnabled => _isDyslexiaFontEnabled;
  bool get isHighContrastEnabled => _isHighContrastEnabled;
  double get textScaleFactor => _textScaleFactor;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDyslexiaFontEnabled = prefs.getBool('isDyslexiaFontEnabled') ?? false;
    _isHighContrastEnabled = prefs.getBool('isHighContrastEnabled') ?? false;
    _textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
  }

  Future<void> toggleDyslexiaFont() async {
    _isDyslexiaFontEnabled = !_isDyslexiaFontEnabled;
    notifyListeners();
    _forceRebuild();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDyslexiaFontEnabled', _isDyslexiaFontEnabled);
  }

  Future<void> toggleHighContrast() async {
    _isHighContrastEnabled = !_isHighContrastEnabled;
    notifyListeners();
    _forceRebuild();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHighContrastEnabled', _isHighContrastEnabled);
  }

  Future<void> updateTextScaleFactor(double value) async {
    _textScaleFactor = value;
    notifyListeners();
    _forceRebuild();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textScaleFactor', _textScaleFactor);
  }

  Future<void> setMaxTextScale() async {
    await updateTextScaleFactor(1.5);
  }

  void _forceRebuild() {
    try {
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
  }
}
