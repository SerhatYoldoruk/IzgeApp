import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/membership_cancellation_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/dues_operations_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/update_info_help_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/rights_obligations_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/how_to_become_member_screen.dart';

class MembershipHelpScreen extends StatelessWidget {
  const MembershipHelpScreen({super.key});

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
          'Üyelik İşlemleri',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // To balance the back button and center title
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Nasıl yardımcı olabiliriz?',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.border, // surface-container-highest
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Help Topics Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return Column(
                  children: [
                    if (isWide)
                      Row(
                        children: [
                          Expanded(
                            child: _buildHelpCard(
                              Icons.person_add, 
                              'Nasıl Üye Olunur?', 
                              'Adım adım üyelik başvuru süreci, gerekli belgeler ve onay aşamaları hakkında detaylı bilgi edinin.',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HowToBecomeMemberScreen()),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildHelpCard(
                              Icons.manage_accounts, 
                              'Bilgilerimi Güncelleme', 
                              'İletişim bilgilerinizi, adresinizi veya mesleki detaylarınızı profiliniz üzerinden nasıl güncelleyeceğinizi öğrenin.',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const UpdateInfoHelpScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _buildHelpCard(
                        Icons.person_add, 
                        'Nasıl Üye Olunur?', 
                        'Adım adım üyelik başvuru süreci, gerekli belgeler ve onay aşamaları hakkında detaylı bilgi edinin.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HowToBecomeMemberScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildHelpCard(
                        Icons.manage_accounts, 
                        'Bilgilerimi Güncelleme', 
                        'İletişim bilgilerinizi, adresinizi veya mesleki detaylarınızı profiliniz üzerinden nasıl güncelleyeceğinizi öğrenin.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UpdateInfoHelpScreen()),
                          );
                        },
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    if (isWide)
                      Row(
                        children: [
                          Expanded(
                            child: _buildHelpCard(
                              Icons.balance, 
                              'Haklar ve Yükümlülükler', 
                              'Dernek üyelerinin genel kuruldaki hakları, tüzük gereği uyması gereken kurallar ve sorumlulukları.',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RightsObligationsScreen()),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildHelpCard(
                              Icons.credit_card, 
                              'Aidat İşlemleri', 
                              'Üyelik aidat ödemeleri, makbuz talepleri ve geçmiş ödeme geçmişi sorgulama adımları.',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DuesOperationsScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _buildHelpCard(
                        Icons.balance, 
                        'Haklar ve Yükümlülükler', 
                        'Dernek üyelerinin genel kuruldaki hakları, tüzük gereği uyması gereken kurallar ve sorumlulukları.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RightsObligationsScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildHelpCard(
                        Icons.credit_card, 
                        'Aidat İşlemleri', 
                        'Üyelik aidat ödemeleri, makbuz talepleri ve geçmiş ödeme geçmişi sorgulama adımları.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DuesOperationsScreen()),
                          );
                        },
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // Cancel Membership Card (Full Width or span 2)
                    _buildHelpCard(
                      Icons.no_accounts,
                      'Üyelik İptali',
                      'Üyeliğinizi dondurma veya tamamen iptal etme prosedürleri, yasal süreçler ve dikkat edilmesi gereken hususlar hakkında kapsamlı rehber.',
                      isError: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MembershipCancellationScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard(IconData icon, String title, String description, {bool isError = false, VoidCallback? onTap}) {
    final bgColor = AppColors.surface; // surface-container
    final iconBgColor = isError ? const Color(0xFF93000A) : const Color(0xFF1A8025); // error-container vs primary-container
    final iconColor = isError ? const Color(0xFFFFDAD6) : const Color(0xFFD3FFC8); // on-error-container vs on-primary-container
    final hoverTitleColor = isError ? const Color(0xFFFFB4AB) : const Color(0xFF7ADC75); // error vs primary
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withOpacity(0.5)), // surface-container-highest
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: hoverTitleColor,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
