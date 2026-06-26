import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

// İlgili modüllerin importları
import 'package:izge_app_frontend/features/activities/presentation/pages/activities_hub_screen.dart';
import 'package:izge_app_frontend/features/development_tracker/presentation/pages/development_tracker_screen.dart';
import 'package:izge_app_frontend/features/rights_guide/presentation/pages/rights_guide_screen.dart';
import 'package:izge_app_frontend/features/meltdown_assistant/presentation/pages/meltdown_assistant_screen.dart';

class ToolsHubScreen extends StatelessWidget {
  const ToolsHubScreen({super.key});

  Widget _buildHubCard(
      BuildContext context, String title, String subtitle, IconData icon, Color color, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.arrow_forward_rounded, color: color, size: 20),
              ],
            )
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
          'Keşfet & Araçlar'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İzge Çözüm Merkezi'.tr(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İhtiyacınız olan tüm gelişim, destek ve eğitim araçları tek bir yerde.'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.70, // Dikdörtgen form, biraz daha uzun
              ),
              delegate: SliverChildListDelegate(
                [
                  _buildHubCard(
                    context,
                    'Mini Aktiviteler'.tr(),
                    'Oyunlar, zamanlayıcı ve günlük rutin takibi.'.tr(),
                    Icons.extension,
                    Colors.purple,
                    const ActivitiesHubScreen(),
                  ),
                  _buildHubCard(
                    context,
                    'Gelişim Takibi'.tr(),
                    'Bilimsel kriterlerle gelişim analizi.'.tr(),
                    Icons.auto_graph,
                    Colors.blue,
                    const DevelopmentTrackerScreen(),
                  ),
                  _buildHubCard(
                    context,
                    'Haklar Rehberi'.tr(),
                    'Yasal haklarınız ve izlemeniz gereken yollar.'.tr(),
                    Icons.gavel,
                    Colors.orange,
                    const RightsGuideScreen(),
                  ),
                  _buildHubCard(
                    context,
                    'Kriz Yönetim Asistanı'.tr(),
                    'Meltdown anında görsel nefes ve ipuçları.'.tr(),
                    Icons.self_improvement,
                    Colors.deepPurple,
                    const MeltdownAssistantScreen(),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}
