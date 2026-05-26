import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _masterSwitch = true;
  bool _newsSwitch = true;
  bool _eventsSwitch = true;
  bool _requestsSwitch = true;
  bool _donationsSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bildirim Ayarları'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uygulama içi ve anlık bildirim tercihlerinizi buradan yönetebilirsiniz.'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            
            // Master Switch
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border), // surface-variant
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genel Bildirimler'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tüm anlık bildirimleri açıp kapatın.'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _masterSwitch,
                    onChanged: (val) {
                      setState(() {
                        _masterSwitch = val;
                      });
                    },
                    activeThumbColor: const Color(0xFF003908), // on-primary
                    activeTrackColor: AppColors.accent,
                    inactiveThumbColor: AppColors.textSecondary,
                    inactiveTrackColor: AppColors.surfaceElevated, // surface-container-high
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Sub Switches Container
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _masterSwitch ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !_masterSwitch,
                child: Column(
                  children: [
                    _buildSubSwitch(
                      title: 'Haberler ve Duyurular'.tr(),
                      subtitle: 'Önemli güncellemeler ve haberler'.tr(),
                      icon: Icons.newspaper,
                      value: _newsSwitch,
                      onChanged: (val) => setState(() => _newsSwitch = val),
                    ),
                    const SizedBox(height: 12),
                    _buildSubSwitch(
                      title: 'Yeni Etkinlikler'.tr(),
                      subtitle: 'Yaklaşan etkinlikler ve davetler'.tr(),
                      icon: Icons.event,
                      value: _eventsSwitch,
                      onChanged: (val) => setState(() => _eventsSwitch = val),
                    ),
                    const SizedBox(height: 12),
                    _buildSubSwitch(
                      title: 'Talep Güncellemeleri'.tr(),
                      subtitle: 'Taleplerinizin durum değişiklikleri'.tr(),
                      icon: Icons.description,
                      value: _requestsSwitch,
                      onChanged: (val) => setState(() => _requestsSwitch = val),
                    ),
                    const SizedBox(height: 12),
                    _buildSubSwitch(
                      title: 'Bağış Hatırlatıcıları'.tr(),
                      subtitle: 'Düzenli bağış bildirimleri'.tr(),
                      icon: Icons.volunteer_activism,
                      value: _donationsSwitch,
                      onChanged: (val) => setState(() => _donationsSwitch = val),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-low
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated, // surface-container-high
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
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF003908),
            activeTrackColor: AppColors.accent,
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.surfaceElevated,
          ),
        ],
      ),
    );
  }
}
