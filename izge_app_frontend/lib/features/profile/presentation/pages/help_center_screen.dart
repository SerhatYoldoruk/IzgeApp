import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/membership_help_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donations_help_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/requests_help_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/technical_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/question_detail_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'Uygulama üzerinden nasıl talep oluşturabilirim?',
      'answer': 'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz.',
      'hasDetail': 'true',
    },
    {
      'question': 'Derneğe nasıl üye olabilirim?',
      'answer': 'Üyelik formunu \'Üyelik İşlemleri\' bölümünden doldurarak başvurunuzu iletebilirsiniz. Başvurunuz yönetim kurulu tarafından değerlendirilip size dönüş sağlanacaktır.',
    },
    {
      'question': 'Bağış makbuzuma nasıl ulaşabilirim?',
      'answer': 'Yaptığınız tüm bağışların elektronik makbuzlarına \'Bağışlar\' menüsü altındaki \'Geçmiş İşlemlerim\' sekmesinden ulaşabilir ve indirebilirsiniz.',
    },
    {
      'question': 'Etkinliklere katılım ücretli mi?',
      'answer': 'Derneğimizin düzenlediği etkinliklerin büyük çoğunluğu üyelerimize ücretsizdir. Ücretli olan özel etkinliklerde, etkinlik detay sayfasında bilet bilgisi açıkça belirtilmektedir.',
    },
  ];

  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.filled(_faqItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yardım Merkezi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Section
            Text(
              'Size nasıl yardımcı\nolabiliriz?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16),
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
                  hintText: 'Sorunuzu arayın (örn: bağış yapmak)',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Categories Bento Grid
            Text(
              'Kategoriler',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildCategoryCard(
                  Icons.badge,
                  'Üyelik İşlemleri',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MembershipHelpScreen()),
                    );
                  },
                ),
                _buildCategoryCard(
                  Icons.volunteer_activism, 
                  'Bağışlar',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DonationsHelpScreen()),
                    );
                  },
                ),
                _buildCategoryCard(
                  Icons.assignment, 
                  'Talepler',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestsHelpScreen()),
                    );
                  },
                ),
                _buildCategoryCard(
                  Icons.build, 
                  'Teknik Destek',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TechnicalSupportScreen()),
                    );
                  },
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // FAQ Section
            Text(
              'Sıkça Sorulan Sorular',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: List.generate(_faqItems.length, (index) {
                    final item = _faqItems[index];
                    return Column(
                      children: [
                        if (index > 0)
                          Divider(height: 1, color: AppColors.border.withOpacity(0.3)),
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              item['question']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            iconColor: AppColors.textSecondary,
                            collapsedIconColor: AppColors.textSecondary,
                            childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                            backgroundColor: const Color(0xFF0E0E0E).withOpacity(0.5), // surface-container-lowest
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _expandedStates[index] = expanded;
                              });
                            },
                            children: [
                              Text(
                                item['answer']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              if (item['hasDetail'] == 'true') ...[
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const QuestionDetailScreen()),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      backgroundColor: const Color(0xFF1A8025).withOpacity(0.2), // primary-container
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text(
                                      'Detaylı Oku',
                                      style: TextStyle(color: Color(0xFF7ADC75), fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Direct Support Action Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A8025), // primary-container
                    AppColors.surface,
                  ],
                  stops: [0.0, 0.6],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF7ADC75).withOpacity(0.2)), // primary
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A8025).withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Color(0xFF7ADC75), // primary
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.support_agent, color: Color(0xFF003908), size: 28), // on-primary
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aradığınızı bulamadınız mı?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Destek ekibimiz size yardımcı olmak için hazır. Hafta içi 09:00 - 18:00 arası canlı destek alabilirsiniz.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 240,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                        );
                      },
                      icon: const Icon(Icons.chat, color: Color(0xFF003908)),
                      label: const Text(
                        'Canlı Destek Başlat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003908),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ADC75), // primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF7ADC75).withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF7ADC75)), // primary
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
