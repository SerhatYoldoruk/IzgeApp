import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class SurveyResultsScreen extends StatelessWidget {
  const SurveyResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Anket Sonuçları',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Summary
            Text(
              'Haftalık Memnuniyet Anketi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A8025).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.groups, color: Color(0xFF1A8025), size: 20),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Katılım',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '1,240 Kişi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Durum',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Tamamlandı',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Question 1
            _buildResultCard(
              question: 'Hizmet kalitemizden memnun musunuz?',
              options: [
                _ResultOption(label: 'Çok Memnunum', percentage: 65, color: const Color(0xFF1A8025)),
                _ResultOption(label: 'Memnunum', percentage: 25, color: const Color(0xFF1A8025).withValues(alpha: 0.6)),
                _ResultOption(label: 'Kararsızım', percentage: 10, color: const Color(0xFF1A8025).withValues(alpha: 0.3)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Question 2
            _buildResultCard(
              question: 'Yeni etkinlik önerilerinizi bizimle paylaşır mısınız?',
              options: [
                _ResultOption(label: 'Eğitim', percentage: 45, color: const Color(0xFF1A8025)),
                _ResultOption(label: 'Sosyal Etkinlik', percentage: 35, color: const Color(0xFF1A8025).withValues(alpha: 0.6)),
                _ResultOption(label: 'Spor', percentage: 20, color: const Color(0xFF1A8025).withValues(alpha: 0.3)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Call to action
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface, // surface-container
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(color: AppColors.border),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.manage_search),
                label: const Text(
                  'Diğer Anketlere Göz At',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({required String question, required List<_ResultOption> options}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-low
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((option) => _buildProgressBar(option)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(_ResultOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                option.label,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${option.percentage}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: option.color.withAlpha(255) == const Color(0xFF1A8025) 
                      ? AppColors.accent 
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.border, // surface-variant
              borderRadius: BorderRadius.circular(4),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: option.percentage / 100),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: option.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultOption {
  final String label;
  final int percentage;
  final Color color;

  _ResultOption({
    required this.label,
    required this.percentage,
    required this.color,
  });
}
