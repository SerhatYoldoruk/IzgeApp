import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/meltdown_assistant/presentation/widgets/breathing_circle.dart';
import 'package:izge_app_frontend/features/meltdown_assistant/presentation/widgets/visual_timer.dart';
import 'package:izge_app_frontend/features/meltdown_assistant/presentation/widgets/calming_sounds.dart';

class MeltdownAssistantScreen extends StatefulWidget {
  const MeltdownAssistantScreen({super.key});

  @override
  State<MeltdownAssistantScreen> createState() => _MeltdownAssistantScreenState();
}

class _MeltdownAssistantScreenState extends State<MeltdownAssistantScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kriz Yönetim Asistanı'.tr(),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Nefes'.tr(), icon: const Icon(Icons.air)),
            Tab(text: 'Rehber'.tr(), icon: const Icon(Icons.menu_book)),
            Tab(text: 'Sesler'.tr(), icon: const Icon(Icons.music_note)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const BreathingCircle(),
          _buildQuickGuide(),
          const CalmingSounds(),
        ],
      ),
    );
  }

  Widget _buildQuickGuide() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'Kriz (Meltdown) Anında Ne Yapmalı?'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildGuideItem(
          icon: Icons.volume_off,
          title: 'Sessizleşin',
          description: 'Çocuğunuz zaten duyusal bir aşırı yüklenme yaşıyor. Konuşmayı minimuma indirin veya tamamen durdurun.',
          color: Colors.blueGrey,
        ),
        _buildGuideItem(
          icon: Icons.lightbulb_outline,
          title: 'Uyaranları Azaltın',
          description: 'Mümkünse ışıkları kapatın veya loşlaştırın. Çevredeki dikkat dağıtıcı ve gürültülü eşyaları uzaklaştırın.',
          color: Colors.orange,
        ),
        _buildGuideItem(
          icon: Icons.back_hand,
          title: 'Fiziksel Temastan Kaçının',
          description: 'Çocuğunuz güvende olduğu sürece ona dokunmayın. Kriz anında dokunulmak durumu daha da kötüleştirebilir.',
          color: Colors.redAccent,
        ),
        _buildGuideItem(
          icon: Icons.security,
          title: 'Güvende Tutun',
          description: 'Sadece kendisine veya çevresine zarar verme riski varsa müdahale edin. Onun yanında olduğunuzu hissettirin ama alan tanıyın.',
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Sakinleşme Sayacı'.tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        const VisualTimer(),
      ],
    );
  }

  Widget _buildGuideItem({required IconData icon, required String title, required String description, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
