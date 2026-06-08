import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/services/tts_service.dart';
import 'info_cards_screen.dart';

class InfoCardDetailScreen extends StatefulWidget {
  final InfoCard card;
  const InfoCardDetailScreen({super.key, required this.card});

  @override
  State<InfoCardDetailScreen> createState() => _InfoCardDetailScreenState();
}

class _InfoCardDetailScreenState extends State<InfoCardDetailScreen> {
  bool _isReading = false;

  @override
  void dispose() {
    if (_isReading) {
      TTSService.instance.stop();
    }
    super.dispose();
  }

  void _toggleReading() async {
    if (_isReading) {
      await TTSService.instance.stop();
      if (mounted) setState(() => _isReading = false);
    } else {
      if (mounted) setState(() => _isReading = true);
      // Construct the text to read
      final textToRead = "${widget.card.title}. ${widget.card.summary}. ${widget.card.content}";
      await TTSService.instance.speak(textToRead);
      // Wait a moment and check if it's still reading to sync UI
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isReading = TTSService.instance.isSpeaking;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: widget.card.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton.icon(
                onPressed: _toggleReading,
                icon: Icon(_isReading ? Icons.stop : Icons.volume_up, color: Colors.white),
                label: Text(
                  _isReading ? 'Durdur' : 'Sesli Oku',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.card.color,
                      widget.card.color.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.card.icon, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.card.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.card.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _categoryLabel(widget.card.category),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.card.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Özet kutusu
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    ),
                    child: Text(
                      widget.card.summary,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Ayraç
                  Row(
                    children: [
                      Container(width: 4, height: 20,
                          decoration: BoxDecoration(
                            color: widget.card.color,
                            borderRadius: BorderRadius.circular(2),
                          )),
                      const SizedBox(width: 10),
                      Text(
                        'Detaylı Bilgi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // İçerik
                  Text(
                    widget.card.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 80), // Fab için boşluk
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'norocesitlilik': return 'Nöroçeşitlilik';
      case 'otizm': return 'Otizm';
      case 'down_sendromu': return 'Down Sendromu';
      default: return 'Genel';
    }
  }
}
