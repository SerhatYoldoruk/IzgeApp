import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_password_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/active_devices_screen.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricsEnabled = false;

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
          'Hesap Güvenliği'.tr(),
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
            // Section 1: ŞİFRE İŞLEMLERİ
            _buildSectionHeader('ŞİFRE İŞLEMLERİ'.tr()),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: _buildActionItem(
                icon: Icons.lock,
                iconColor: const Color(0xFF1A8025), // primary-container
                iconBgColor: const Color(0xFF1A8025).withOpacity(0.2),
                title: 'Şifre Değiştir'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 2: GÜVENLİK KATMANLARI
            _buildSectionHeader('GÜVENLİK KATMANLARI'.tr()),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildToggleItem(
                    icon: Icons.verified_user,
                    title: 'İki Faktörlü Doğrulama'.tr(),
                    subtitle: 'Ekstra güvenlik şartları'.tr(),
                    value: _twoFactorEnabled,
                    onChanged: (val) {
                      setState(() {
                        _twoFactorEnabled = val;
                      });
                    },
                  ),
                  Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
                  _buildToggleItem(
                    icon: Icons.fingerprint,
                    title: 'Biyometrik Giriş\n(FaceID/Parmak İzi)'.tr(),
                    value: _biometricsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _biometricsEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Section 3: OTURUM YÖNETİMİ
            _buildSectionHeader('OTURUM YÖNETİMİ'.tr()),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: _buildActionItem(
                icon: Icons.devices,
                iconColor: AppColors.textPrimary,
                iconBgColor: AppColors.border, // surface-variant
                title: 'Aktif Cihazlar'.tr(),
                subtitle: 'Bu Cihaz: iPhone 14 Pro'.tr(),
                subtitleColor: const Color(0xFF7ADC75), // primary
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActiveDevicesScreen()),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 4: HESAP İŞLEMLERİ
            _buildSectionHeader('HESAP İŞLEMLERİ'.tr()),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: _buildActionItem(
                icon: Icons.delete_forever,
                iconColor: const Color(0xFFE57373),
                iconBgColor: const Color(0xFFE57373).withOpacity(0.2),
                title: 'Hesabımı Sil'.tr(),
                subtitle: 'Bu işlem kalıcıdır'.tr(),
                subtitleColor: const Color(0xFFE57373),
                titleColor: const Color(0xFFE57373),
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary, // text-on-surface-variant
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface, // surface-container
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.surfaceElevated), // surface-container-high
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
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
                        fontWeight: FontWeight.w500,
                        color: titleColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: subtitleColor ?? AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration( color: AppColors.border, // surface-variant
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
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
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFD3FFC8), // on-primary-container
            activeTrackColor: const Color(0xFF1A8025), // primary-container
            inactiveThumbColor: AppColors.textSecondary, // on-surface-variant
            inactiveTrackColor: AppColors.border, // surface-variant
          ),
        ],
      ),
    );
  }
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Emin misiniz?'.tr(),
            style: const TextStyle(color: Color(0xFFE57373)),
          ),
          content: Text(
            'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem kalıcıdır ve geri alınamaz.'.tr(),
            style: TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'İptal'.tr(),
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hesap silme talebiniz alınmıştır.'.tr()),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  Navigator.pop(context); // Pop screen
                }
              },
              child: Text(
                'Hesabımı Sil'.tr(),
                style: const TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
