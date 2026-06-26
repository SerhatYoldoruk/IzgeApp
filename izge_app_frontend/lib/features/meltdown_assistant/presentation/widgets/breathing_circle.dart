import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  
  String _phaseText = 'Başla';
  String _instructionText = 'Derin bir nefes almaya hazırlanın...';

  @override
  void initState() {
    super.initState();
    // 4s Inhale + 4s Hold + 6s Exhale = 14s total cycle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 100.0, end: 250.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 4 / 14 * 100, // Nefes al (4s)
      ),
      TweenSequenceItem(
        tween: ConstantTween(250.0),
        weight: 4 / 14 * 100, // Tut (4s)
      ),
      TweenSequenceItem(
        tween: Tween(begin: 250.0, end: 100.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 6 / 14 * 100, // Nefes ver (6s)
      ),
    ]).animate(_controller);

    _controller.addListener(() {
      final val = _controller.value;
      setState(() {
        if (val < (4 / 14)) {
          _phaseText = 'Nefes Al'.tr();
          _instructionText = 'Burnunuzdan yavaşça nefes alın...'.tr();
        } else if (val < (8 / 14)) {
          _phaseText = 'Tut'.tr();
          _instructionText = 'Nefesinizi tutun...'.tr();
        } else {
          _phaseText = 'Nefes Ver'.tr();
          _instructionText = 'Ağzınızdan yavaşça nefes verin...'.tr();
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  void _toggleAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
      setState(() {
        _phaseText = 'Duraklatıldı'.tr();
        _instructionText = 'Devam etmek için dokunun'.tr();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: _sizeAnimation.value,
                      height: _sizeAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withOpacity(0.2),
                        border: Border.all(color: AppColors.accent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: _sizeAnimation.value / 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _phaseText,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _instructionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _toggleAnimation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.accent,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: Icon(
                _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
