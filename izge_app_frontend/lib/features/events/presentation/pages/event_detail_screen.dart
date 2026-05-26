import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/event_success_screen.dart';
import 'package:izge_app_frontend/core/state/activity_state.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isLiked = false;
  bool isSaved = false;

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
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    ActivityState.instance.toggleLike(isLiked);
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
    ActivityState.instance.toggleSave(isSaved);
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
          'Etkinlik Detayı'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? AppColors.accent : AppColors.textPrimary),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? AppColors.accent : AppColors.textPrimary),
            onPressed: _toggleSave,
          ),
          IconButton(
            icon: Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                      ),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCllOx7_74sZN8rzuPNmyI7_gkL8cVKHs4JeeQ5G9mVgYnrtqYrJLn8vKcpPkoIGrFluLq8mXXYbigClLWM7fRorEM7Fu353qUXCRhjzV11HAmAr5v0t6rqxRTrp-xaca5G7IJI8Q9lVSHSqDIRG-sEqb8KLhXnYz4Xyg8AVtfPdfhRdOEV6qrXHvZSYZzUycYd8FKie0xyKTxOQITbVI4QBgx4iNod7rGwVkfIHqT8uqjZuCM8L2hyoeA-kmc5MiLyKnIE5qMm_PQC',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.image, size: 64, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.background,
                              AppColors.background.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Content Container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      // Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container/20
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_activity, color: AppColors.accent, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Seminer'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Title
                      Text(
                        'Engelsiz Yaşam Buluşması'.tr(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Quick Info Cards
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated, // surface-container-low
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.border, // surface-variant
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.event, color: AppColors.accent),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '12 Haziran 2024'.tr(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    'Çarşamba'.tr(),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '14:00',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                ),
                                Text(
                                  'Başlangıç'.tr(),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated, // surface-container-low
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.border, // surface-variant
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.location_on, color: AppColors.accent),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kültür Merkezi'.tr(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    'Ankara'.tr(),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.directions, color: AppColors.accent),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      // Organizer
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.border.withOpacity(0.3)),
                            bottom: BorderSide(color: AppColors.border.withOpacity(0.3)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBfwM6w-3SQxZCq-Ktf71PfW9pl5JvVec5T5cMMzrx_2LkqVmsF1_kEIl-z7Y9E4kbAxxxlCuZIxJTbVlWYxjc21ZMl2LK-FvliXntVjRH3zuwRqAAA4OzWxbHvuP-oKdHtnj7R-XJbcapwRk2lhRpzyz4xvHQ-cW_oXUFIFkcz-IxElM9IuNK2VqULAfydBubEO1b3BMptv6JarOcVPvpJ6iRgpNBtAYLDZx76BBf-_dzSjwU4ACCRthGnC6JNDnYkDbaSJKbQsHMV',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.business, color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ORGANİZATÖR'.tr(),
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                ),
                                Text(
                                  'İzge Derneği'.tr(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      // Description
                      Text(
                        'Etkinlik Hakkında'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Engelli bireylerin sosyal hayata katılımını desteklemek ve farkındalık yaratmak amacıyla düzenlediğimiz "Engelsiz Yaşam Buluşması"nda sizleri de aramızda görmekten mutluluk duyarız.'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bu özel etkinlikte, alanında uzman konuşmacılarımızın sunumları, atölye çalışmaları ve interaktif paneller yer alacaktır. Birlikte daha güçlü, erişilebilir ve kapsayıcı bir toplum inşa etmek için fikir alışverişinde bulunacağız.'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Action Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 40),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withOpacity(0.9), // surface-container-high/90
                border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.2))),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showRegistrationBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: const Color(0xFF003908), // on-primary
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 8,
                  shadowColor: AppColors.accent.withOpacity(0.5),
                ),
                icon: const Icon(Icons.person_add),
                label: Text(
                  'Etkinliğe Katıl'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistrationBottomSheet(BuildContext context) {
    bool needsWheelchair = false;
    bool needsSignLanguage = false;
    bool hasCompanion = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated, // surface-container-low
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Etkinlik Kaydı'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lütfen varsa özel gereksinimlerinizi belirtin. Bu bilgiler, etkinliği sizin için daha erişilebilir hale getirmemize yardımcı olacaktır.'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Options
                  SwitchListTile(
                    title: Text('Tekerlekli Sandalye Erişimi'.tr(), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    subtitle: Text('Rampa veya asansör ihtiyacım var'.tr(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    value: needsWheelchair,
                    activeThumbColor: AppColors.accent,
                    onChanged: (bool value) {
                      setState(() {
                        needsWheelchair = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('İşaret Dili Çevirmeni'.tr(), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    value: needsSignLanguage,
                    activeThumbColor: AppColors.accent,
                    onChanged: (bool value) {
                      setState(() {
                        needsSignLanguage = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Refakatçi İle Katılacağım'.tr(), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    value: hasCompanion,
                    activeThumbColor: AppColors.accent,
                    onChanged: (bool value) {
                      setState(() {
                        hasCompanion = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ActivityState.instance.toggleEvent(true);
                        Navigator.pop(context); // Close bottom sheet
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const EventSuccessScreen())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: const Color(0xFF003908),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: Text(
                        'Kaydı Tamamla'.tr(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
