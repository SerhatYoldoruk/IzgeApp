import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';

class MembershipCancellationScreen extends StatelessWidget {
  const MembershipCancellationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Üyelik İptali',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // To balance the back button and center title
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 100),
        child: Column(
          children: [
            // Intro Notice
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: BorderSide(color: Color(0xFFFFB4AB), width: 4), // error
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, color: Color(0xFFFFB4AB), size: 24), // error
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayrılmak istediğinize emin misiniz?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Üyeliğinizi iptal etmek yerine dondurmayı tercih edebilirsiniz. İptal işlemi kalıcıdır ve önceki bağış geçmişinize veya etkinlik katılımlarınıza erişimi sonlandırır.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Options: Freeze vs Cancel
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                void freezeOnTap() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Üyeliğiniz donduruldu. İstediğiniz zaman tekrar aktif edebilirsiniz.'),
                      backgroundColor: Color(0xFF1A8025),
                    ),
                  );
                  Navigator.pop(context);
                }
                void cancelOnTap() => _showCancelDialog(context);
                return Column(
                  children: [
                    if (isWide)
                      Row(
                        children: [
                          Expanded(child: _buildOptionCard(Icons.ac_unit, 'Üyeliği Dondur', 'Hesabınızı geçici olarak askıya alın. İstediğiniz zaman tekrar aktif edebilirsiniz. Verileriniz güvende kalır.', false, onTap: freezeOnTap)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildOptionCard(Icons.delete_forever, 'Kalıcı İptal', 'Hesabınızı ve tüm verilerinizi kalıcı olarak silin. Bekleyen ödemeleriniz varsa iptal öncesi tamamlanmalıdır.', true, onTap: cancelOnTap)),
                        ],
                      )
                    else ...[
                      _buildOptionCard(Icons.ac_unit, 'Üyeliği Dondur', 'Hesabınızı geçici olarak askıya alın. İstediğiniz zaman tekrar aktif edebilirsiniz. Verileriniz güvende kalır.', false, onTap: freezeOnTap),
                      const SizedBox(height: 16),
                      _buildOptionCard(Icons.delete_forever, 'Kalıcı İptal', 'Hesabınızı ve tüm verilerinizi kalıcı olarak silin. Bekleyen ödemeleriniz varsa iptal öncesi tamamlanmalıdır.', true, onTap: cancelOnTap),
                    ],
                  ],
                );
              },
            ),
            
            SizedBox(height: 32),
            
            // Information List
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border.withOpacity(0.5)), // surface-variant
                      ),
                    ),
                    child: Text(
                      'Önemli Bilgilendirme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.check_circle, 'İptal talebiniz 3 iş günü içerisinde işleme alınacaktır.'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.payments, 'Varsa bekleyen son aidat borcunuz tahsil edildikten sonra iptal gerçekleşir.'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.contact_mail, 'Detaylı bilgi ve haklarınız için gizlilik sözleşmemizi inceleyebilirsiniz.'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Bottom Action Area
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                      );
                    },
                    icon: Icon(Icons.headset_mic, color: AppColors.textPrimary),
                    label: Text(
                      'Bize Ulaşın',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.border, // surface-variant
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.border.withOpacity(0.5)), // outline-variant
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: TextButton(
                    onPressed: () => _showCancelDialog(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'İptal İşlemini Başlat',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFB4AB), // error
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Kalıcı İptal', style: TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
        content: Text('Bu işlem geri alınamaz. Üyeliğinizi kalıcı olarak iptal etmek istediğinize emin misiniz?', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Vazgeç', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('İptal talebiniz alınmıştır. 3 iş günü içerisinde işleme alınacaktır.'), backgroundColor: Color(0xFF93000A)),
              );
              Navigator.pop(context);
            },
            child: const Text('İptal Et', style: TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title, String description, bool isError, {VoidCallback? onTap}) {
    final borderColor = isError ? const Color(0xFF93000A).withOpacity(0.3) : AppColors.border; // error-container vs outline-variant
    final iconBgColor = isError ? const Color(0xFF93000A).withOpacity(0.2) : const Color(0xFF1A8025).withOpacity(0.2); // error-container vs primary-container
    final iconColor = isError ? const Color(0xFFFFB4AB) : const Color(0xFF7ADC75); // error vs primary-fixed
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated, // surface-container-high
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF7ADC75), size: 20), // primary-fixed
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
