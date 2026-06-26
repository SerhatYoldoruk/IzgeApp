import 'dart:async';
import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class VisualTimer extends StatefulWidget {
  const VisualTimer({super.key});

  @override
  State<VisualTimer> createState() => _VisualTimerState();
}

class _VisualTimerState extends State<VisualTimer> {
  Timer? _timer;
  int _totalSeconds = 180; // Default 3 minutes
  int _currentSeconds = 180;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() {
          _currentSeconds--;
        });
      } else {
        _timer!.cancel();
        setState(() => _isRunning = false);
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer(int seconds) {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _totalSeconds = seconds;
      _currentSeconds = seconds;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _currentSeconds ~/ 60;
    int seconds = _currentSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeOption('1 Dk', 60),
            const SizedBox(width: 8),
            _buildTimeOption('3 Dk', 180),
            const SizedBox(width: 8),
            _buildTimeOption('5 Dk', 300),
          ],
        ),
        const SizedBox(height: 32),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: _currentSeconds / _totalSeconds,
                strokeWidth: 12,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _currentSeconds < 10 ? Colors.red : AppColors.accent,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _currentSeconds == 0 ? 'Süre Bitti!'.tr() : 'Kalan Süre'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _currentSeconds == 0 ? null : (_isRunning ? _pauseTimer : _startTimer),
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? 'Duraklat'.tr() : 'Başlat'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () => _resetTimer(_totalSeconds),
              icon: const Icon(Icons.refresh),
              label: Text('Sıfırla'.tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTimeOption(String label, int seconds) {
    final isSelected = _totalSeconds == seconds;
    return ChoiceChip(
      label: Text(label.tr()),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _resetTimer(seconds);
        }
      },
      selectedColor: AppColors.accent.withOpacity(0.2),
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.accent : Colors.transparent,
      ),
    );
  }
}
