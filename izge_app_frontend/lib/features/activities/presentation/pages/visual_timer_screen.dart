import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'dart:async';

class VisualTimerScreen extends StatefulWidget {
  const VisualTimerScreen({super.key});

  @override
  State<VisualTimerScreen> createState() => _VisualTimerScreenState();
}

class _VisualTimerScreenState extends State<VisualTimerScreen> {
  int _totalSeconds = 60 * 5; // Default 5 minutes
  int _currentSeconds = 60 * 5;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() => _currentSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _showTimeUpDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  void _setMinutes(int minutes) {
    setState(() {
      _totalSeconds = minutes * 60;
      _currentSeconds = _totalSeconds;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Süre Doldu!'.tr(), style: TextStyle(color: AppColors.accent)),
        content: Text('Aktivite süresi tamamlandı.'.tr(), style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text('Tamam'.tr(), style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    int minutes = _currentSeconds ~/ 60;
    int seconds = _currentSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _currentSeconds / _totalSeconds;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Görsel Zamanlayıcı'.tr(), style: TextStyle(color: AppColors.accent)),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimePresetBtn(label: '1 dk'.tr(), minutes: 1, onTap: () => _setMinutes(1)),
                const SizedBox(width: 8),
                _TimePresetBtn(label: '5 dk'.tr(), minutes: 5, onTap: () => _setMinutes(5)),
                const SizedBox(width: 8),
                _TimePresetBtn(label: '10 dk'.tr(), minutes: 10, onTap: () => _setMinutes(10)),
              ],
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 20,
                    backgroundColor: AppColors.surfaceElevated,
                    color: progress > 0.2 ? AppColors.accent : Colors.red,
                  ),
                  Center(
                    child: Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton.icon(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: Text('Başlat'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause),
                    label: Text('Duraklat'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: Text('Sıfırla'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceElevated,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePresetBtn extends StatelessWidget {
  final String label;
  final int minutes;
  final VoidCallback onTap;

  const _TimePresetBtn({required this.label, required this.minutes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surfaceElevated,
        foregroundColor: AppColors.textPrimary,
      ),
      child: Text(label),
    );
  }
}
