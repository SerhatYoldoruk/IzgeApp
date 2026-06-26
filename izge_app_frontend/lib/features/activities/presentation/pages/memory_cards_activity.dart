import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';

class MemoryCardsActivity extends StatefulWidget {
  const MemoryCardsActivity({super.key});

  @override
  State<MemoryCardsActivity> createState() => _MemoryCardsActivityState();
}

class _MemoryCardsActivityState extends State<MemoryCardsActivity> {
  final List<String> _emojis = ['🍎', '🐶', '🚗', '🎈', '⭐', '🎸'];
  late List<String> _cards;
  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  
  int _previousIndex = -1;
  bool _isProcessing = false;
  int _moves = 0;
  int _matches = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initGame();
  }

  void _initGame() {
    _cards = [..._emojis, ..._emojis];
    _cards.shuffle(Random());
    _isFlipped = List.generate(_cards.length, (index) => false);
    _isMatched = List.generate(_cards.length, (index) => false);
    _previousIndex = -1;
    _isProcessing = false;
    _moves = 0;
    _matches = 0;
    setState(() {});
  }

  void _onCardTap(int index) {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) return;

    setState(() {
      _isFlipped[index] = true;
    });

    if (_previousIndex == -1) {
      _previousIndex = index;
    } else {
      _moves++;
      _isProcessing = true;

      if (_cards[_previousIndex] == _cards[index]) {
        // Match!
        setState(() {
          _isMatched[_previousIndex] = true;
          _isMatched[index] = true;
        });
        _matches++;
        _previousIndex = -1;
        _isProcessing = false;

        if (_matches == _emojis.length) {
          _confettiController.play();
          _showWinDialog();
        }
      } else {
        // No match
        Timer(const Duration(milliseconds: 800), () {
          setState(() {
            _isFlipped[_previousIndex] = false;
            _isFlipped[index] = false;
          });
          _previousIndex = -1;
          _isProcessing = false;
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Harika İş!'.tr(), style: TextStyle(color: AppColors.accent)),
        content: Text(
          'Hafıza oyununu $_moves hamlede tamamladın.'.tr(),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
            },
            child: Text('Tekrar Oyna'.tr(), style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hafıza Kartları'.tr(), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
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
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hamle: $_moves'.tr(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Eşleşme: $_matches/${_emojis.length}'.tr(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _isFlipped[index] || _isMatched[index] ? AppColors.surfaceElevated : AppColors.accent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isMatched[index] ? Colors.green : AppColors.border,
                            width: _isMatched[index] ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isFlipped[index] || _isMatched[index] ? _cards[index] : '?',
                            style: TextStyle(
                              fontSize: 48,
                              color: _isFlipped[index] || _isMatched[index] ? AppColors.textPrimary : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // down
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
