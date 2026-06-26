import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'dart:math';

class ColorMatchActivity extends StatefulWidget {
  const ColorMatchActivity({super.key});

  @override
  State<ColorMatchActivity> createState() => _ColorMatchActivityState();
}

class _ColorMatchActivityState extends State<ColorMatchActivity> {
  final Map<Color, String> _colorNames = {
    Colors.red: 'Kırmızı',
    Colors.blue: 'Mavi',
    Colors.green: 'Yeşil',
    Colors.yellow: 'Sarı',
  };

  late List<Color> _items;
  late List<Color> _targets;
  int _score = 0;
  bool _isWinner = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    setState(() {
      _items = _colorNames.keys.toList()..shuffle(Random());
      _targets = _colorNames.keys.toList()..shuffle(Random());
      _score = 0;
      _isWinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Renk Eşleştirme'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initGame,
            tooltip: 'Yeniden Başla'.tr(),
          )
        ],
      ),
      body: _isWinner
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 100, color: Colors.amber),
                  const SizedBox(height: 24),
                  Text(
                    'Tebrikler!'.tr(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tüm renkleri doğru eşleştirdin.'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _initGame,
                    icon: const Icon(Icons.play_arrow),
                    label: Text('Tekrar Oyna'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Sürüklenebilir Öğeler
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _items.map((color) {
                      return Draggable<Color>(
                        data: color,
                        feedback: _buildColorCircle(color, isDragging: true),
                        childWhenDragging: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: _buildColorCircle(color),
                      );
                    }).toList(),
                  ),
                  
                  // Hedefler
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _targets.map((targetColor) {
                      return DragTarget<Color>(
                        onWillAccept: (data) => data == targetColor,
                        onAccept: (data) {
                          setState(() {
                            _items.remove(data);
                            _score++;
                            if (_score == _colorNames.length) {
                              _isWinner = true;
                            }
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          final accepted = !_items.contains(targetColor);
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: accepted ? targetColor : AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: candidateData.isNotEmpty ? AppColors.accent : AppColors.border,
                                width: candidateData.isNotEmpty ? 4 : 2,
                              ),
                            ),
                            child: Center(
                              child: accepted
                                  ? const Icon(Icons.check, color: Colors.white, size: 40)
                                  : Text(
                                      _colorNames[targetColor]!,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildColorCircle(Color color, {bool isDragging = false}) {
    return Container(
      width: isDragging ? 90 : 80,
      height: isDragging ? 90 : 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: isDragging ? 16 : 8,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
    );
  }
}
