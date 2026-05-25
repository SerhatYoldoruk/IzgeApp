import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Talep Detayı',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32).copyWith(bottom: 150),
        child: Column(
          children: [
            // Ticket Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceElevated), // surface-container-high
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TLP-84729',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface, // surface-container
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '12 Eki 2023',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tekerlekli Sandalye Bakımı',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Status Message Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A8025).withOpacity(0.1), // primary-container/10
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1A8025).withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A8025), // primary-container
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info, color: Color(0xFFD3FFC8), size: 20), // on-primary-container
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Durum Güncellemesi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7ADC75), // primary
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Talebiniz ilgili uzman ekibimize iletilmiştir. İnceleme süreci devam etmektedir.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Visual Progress Stepper (Vertical)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceElevated),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Süreç Takibi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 24),
                  Stack(
                    children: [
                      // Vertical Line
                      Positioned(
                        left: 15,
                        top: 16,
                        bottom: 32,
                        width: 2,
                        child: Container(
                          color: AppColors.surfaceElevated, // surface-container-high
                        ),
                      ),
                      
                      Column(
                        children: [
                          _buildVerticalStep(
                            icon: Icons.check,
                            title: 'Alındı',
                            subtitle: 'Talebiniz sisteme kaydedildi.',
                            isActive: true,
                            isCompleted: true,
                          ),
                          SizedBox(height: 32),
                          _buildVerticalStep(
                            icon: Icons.circle,
                            title: 'Değerlendirmede',
                            subtitle: 'Uzman ekibimiz talebinizi inceliyor.',
                            isActive: true,
                            isCompleted: false,
                          ),
                          const SizedBox(height: 32),
                          _buildVerticalStep(
                            icon: null,
                            title: 'Onay',
                            subtitle: 'Gerekli onaylar bekleniyor.',
                            isActive: false,
                            isCompleted: false,
                          ),
                          const SizedBox(height: 32),
                          _buildVerticalStep(
                            icon: null,
                            title: 'Tamamlandı',
                            subtitle: '',
                            isActive: false,
                            isCompleted: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.9),
          border: Border(
            top: BorderSide(color: AppColors.surface), // surface-container
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.support_agent, color: AppColors.background), // background
                  label: Text(
                    'Canlı Desteğe Bağlan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary, // on-background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 8,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceElevated, // surface-container-high
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Geri Dön',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalStep({
    required IconData? icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive 
                  ? (isCompleted ? Color(0xFF1A8025) : AppColors.surface) 
                  : AppColors.surfaceElevated,
              shape: BoxShape.circle,
              border: isActive && !isCompleted ? Border.all(color: const Color(0xFF7ADC75), width: 2) : (isActive ? null : Border.all(color: AppColors.border, width: 2)),
              boxShadow: isActive && isCompleted ? [
                BoxShadow(color: const Color(0xFF1A8025).withOpacity(0.3), blurRadius: 10)
              ] : null,
            ),
            child: isActive && isCompleted
                ? Icon(Icons.check, color: Color(0xFFD3FFC8), size: 18)
                : (isActive && !isCompleted 
                    ? Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Color(0xFF7ADC75), shape: BoxShape.circle))) 
                    : null),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isActive && !isCompleted ? Color(0xFF7ADC75) : (isActive ? AppColors.textPrimary : AppColors.textSecondary),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
