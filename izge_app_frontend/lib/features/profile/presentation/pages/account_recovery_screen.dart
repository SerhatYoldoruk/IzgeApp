import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';

class AccountRecoveryScreen extends StatefulWidget {
  const AccountRecoveryScreen({super.key});

  @override
  State<AccountRecoveryScreen> createState() => _AccountRecoveryScreenState();
}

class _AccountRecoveryScreenState extends State<AccountRecoveryScreen> {
  String _selectedMethod = 'email';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header / Illustration Area
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated, // surface-container-high
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF7ADC75).withOpacity(0.2), width: 2), // primary/20
                        ),
                      ),
                      Icon(Icons.lock_person, color: Color(0xFF7ADC75), size: 48), // primary
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Hesap Kurtarma'.tr(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Güvenliğiniz için kimliğinizi doğrulamamız gerekiyor. Lütfen aşağıdaki yöntemlerden birini seçin.'.tr(),
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),

                // Verification Options
                _buildRadioOption(
                  value: 'email',
                  title: 'E-posta ile Doğrulama'.tr(),
                  subtitle: 'Sistemde kayıtlı e-posta adresinizle'.tr(),
                  icon: Icons.mail,
                ),
                const SizedBox(height: 16),
                _buildRadioOption(
                  value: 'sms',
                  title: 'Kayıtlı Telefon Numarası ile SMS'.tr(),
                  subtitle: 'Kayıtlı numaranıza kod gönderilir'.tr(),
                  icon: Icons.sms,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7ADC75), // primary
                      foregroundColor: const Color(0xFF003908), // on-primary
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 4,
                      shadowColor: const Color(0xFF1A8025).withOpacity(0.4), // primary-container
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Devam Et'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.border), // outline-variant
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    child: Text('İptal Et'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer Help
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                    );
                  },
                  icon: const Icon(Icons.support_agent, color: Color(0xFF7ADC75), size: 16),
                  label: Text(
                    'Destek Merkezi ile İletişime Geç'.tr(),
                    style: TextStyle(color: Color(0xFF7ADC75), fontSize: 14), // primary
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF7ADC75).withOpacity(0.05) 
              : AppColors.surfaceElevated.withOpacity(0.4), // glass-card
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF7ADC75) 
                : Colors.white.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF7ADC75) : AppColors.border, // outline-variant
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7ADC75),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration( color: AppColors.surface, // surface-container
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: isSelected ? Color(0xFF7ADC75) : AppColors.textSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
