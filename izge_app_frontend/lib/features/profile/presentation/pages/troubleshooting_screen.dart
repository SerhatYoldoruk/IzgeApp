import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';

class TroubleshootingScreen extends StatefulWidget {
  const TroubleshootingScreen({super.key});

  @override
  State<TroubleshootingScreen> createState() => _TroubleshootingScreenState();
}

class _TroubleshootingScreenState extends State<TroubleshootingScreen> {
  final List<Map<String, dynamic>> _issues = [
    {
      'icon': Icons.upload_file,
      'iconColor': AppColors.error,
      'title': 'Belge yükleme hatası alıyorum',
      'steps': [
        'İnternet bağlantınızı kontrol edin.',
        'Belge boyutunun 5MB\'ı aşmadığından emin olun.',
        'Desteklenen formatlarda (PDF, JPG, PNG) yükleme yaptığınızı doğrulayın.',
        'Uygulamayı kapatıp tekrar açmayı deneyin.',
      ],
    },
    {
      'icon': Icons.smartphone,
      'iconColor': AppColors.textSecondary, // tertiary
      'title': 'Uygulama donma veya çökme sorunu',
      'steps': [
        'Uygulamanın güncel sürümünü kullandığınızdan emin olun (App Store veya Google Play\'i kontrol edin).',
        'Cihazınızda yeterli depolama alanı olduğundan emin olun.',
        'Cihazınızın ayarlarından uygulama önbelleğini temizleyin.',
        'Sorun devam ederse uygulamayı silip yeniden yükleyin.',
      ],
    },
    {
      'icon': Icons.location_on,
      'iconColor': const Color(0xFF7ADC75), // primary
      'title': 'Adres doğrulama problemi',
      'steps': [
        'Cihazınızın konum servislerinin açık olduğundan emin olun.',
        'Uygulamaya konum erişim izni verdiğinizi kontrol edin (Ayarlar > İzge App > Konum).',
        'Manuel adres girerken posta kodunuzu doğru yazdığınızdan emin olun.',
      ],
    },
  ];

  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.filled(_issues.length, false);
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
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sorun Giderme',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Text(
              'Nasıl yardımcı olabiliriz?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sık karşılaşılan sorunlar için aşağıdaki çözüm adımlarını inceleyin.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Sorununuzu arayın...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface, // surface-container
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Accordion/List of Issues
            ...List.generate(_issues.length, (index) {
              final issue = _issues[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface, // surface-container
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedStates[index] = expanded;
                      });
                    },
                    title: Row(
                      children: [
                        Icon(issue['icon'], color: issue['iconColor']),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            issue['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    iconColor: AppColors.textSecondary,
                    collapsedIconColor: AppColors.textSecondary,
                    childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.border.withOpacity(0.3)), // outline-variant/30
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(issue['steps'].length, (stepIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${stepIndex + 1}. ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      issue['steps'][stepIndex],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            SizedBox(height: 32),
            
            // Interactive Support Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-high
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Decorative subtle gradients
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7ADC75).withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF7ADC75).withOpacity(0.1), blurRadius: 40),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7ADC75).withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF7ADC75).withOpacity(0.1), blurRadius: 40),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A8025), // primary-container
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.support_agent, color: Color(0xFFD3FFC8), size: 32),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Hala sorun mu yaşıyorsunuz?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Destek ekibimiz size yardımcı olmak için burada.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
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
                          icon: const Icon(Icons.chat_bubble, color: Color(0xFF003908)),
                          label: const Text(
                            'Canlı Destek Başlat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003908), // on-primary
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7ADC75), // primary
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
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
