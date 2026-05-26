import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/my_events_screen.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class EventSuccessScreen extends StatefulWidget {
  const EventSuccessScreen({super.key});

  @override
  State<EventSuccessScreen> createState() => _EventSuccessScreenState();
}

class _EventSuccessScreenState extends State<EventSuccessScreen> {
  @override
  void initState() {
    super.initState();
    LanguageController.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'İzge App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Subtle Background Glow
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                // We'd use ImageFilter.blur if we needed true blur, but this soft opacity circle works as a glow
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon & Title
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container/20
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.accent,
                      size: 64,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Katılım Onayı'.tr(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kaydınız başarıyla oluşturulmuştur. Etkinlik detayları ve güncellemeler için takipte kalın.'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  
                  // Event Summary Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated, // surface-container-high
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          icon: Icons.event,
                          label: 'Etkinlik'.tr(),
                          value: 'Engelsiz Yaşam Buluşması'.tr(),
                        ),
                        Divider(color: AppColors.border, height: 32),
                        _buildSummaryRow(
                          icon: Icons.calendar_today,
                          label: 'Tarih'.tr(),
                          value: '12 Haziran 2024'.tr(),
                        ),
                        Divider(color: AppColors.border, height: 32),
                        _buildSummaryRow(
                          icon: Icons.location_on,
                          label: 'Konum'.tr(),
                          value: 'Kültür Merkezi'.tr(),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyEventsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: const Color(0xFF003908),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: AppColors.accent.withOpacity(0.3),
                    ),
                    child: Text(
                      'Etkinliklerime Git'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Anasayfaya Dön'.tr(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration( color: AppColors.border, // surface-variant
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
