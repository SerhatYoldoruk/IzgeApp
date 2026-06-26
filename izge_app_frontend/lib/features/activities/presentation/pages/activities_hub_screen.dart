import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'color_match_activity.dart';
import 'visual_timer_screen.dart';
import 'memory_cards_activity.dart';
import 'daily_routine_screen.dart';
import 'drawing_activity.dart';

class ActivitiesHubScreen extends StatelessWidget {
  const ActivitiesHubScreen({super.key});

  Widget _buildActivityCard(
      BuildContext context, String title, String subtitle, IconData icon, Color color, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_fill, color: color, size: 36),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Mini Aktiviteler'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Günlük Pratikler'.tr(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Eğlenceli ve öğretici erişilebilir mini aktiviteler.'.tr(),
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          
          _buildActivityCard(
            context,
            'Renk & Şekil Eşleştirme',
            'Motor becerileri ve görsel algıyı destekler.',
            Icons.category,
            Colors.blue,
            const ColorMatchActivity(),
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            context,
            'Serbest Boyama',
            'İnce motor becerilerini ve yaratıcılığı artırır.',
            Icons.brush,
            Colors.pink,
            const DrawingActivity(),
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            context,
            'Görsel Zamanlayıcı',
            'Rutin geçişleri ve zaman yönetimini kolaylaştırır.',
            Icons.timer,
            Colors.orange,
            const VisualTimerScreen(),
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            context,
            'Hafıza Kartları',
            'Görsel hafıza ve dikkati geliştirir.',
            Icons.dashboard,
            Colors.purple,
            const MemoryCardsActivity(),
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            context,
            'Günlük Rutin Takibi',
            'Özbakım becerilerini ve bağımsızlığı destekler.',
            Icons.checklist,
            Colors.green,
            const DailyRoutineScreen(),
          ),
        ],
      ),
    );
  }
}
