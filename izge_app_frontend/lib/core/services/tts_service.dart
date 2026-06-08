import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  TTSService._();
  static final TTSService instance = TTSService._();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    try {
      await _flutterTts.awaitSpeakCompletion(true);

      bool isTrAvailable = await _flutterTts.isLanguageAvailable("tr-TR");
      if (isTrAvailable) {
        await _flutterTts.setLanguage("tr-TR");
      } else {
        bool isTrFallback = await _flutterTts.isLanguageAvailable("tr_TR");
        if (isTrFallback) {
          await _flutterTts.setLanguage("tr_TR");
        }
      }

      await _flutterTts.setSpeechRate(0.45); // Slightly slower for better accessibility
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setCancelHandler(() {
        _isSpeaking = false;
      });
      
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint("TTS Error: $msg");
      });
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    if (_isSpeaking) {
      await stop();
    }
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint("TTS Stop Error: $e");
    } finally {
      _isSpeaking = false;
    }
  }
}
