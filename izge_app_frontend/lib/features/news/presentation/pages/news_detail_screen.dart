import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/state/activity_state.dart';
import 'package:izge_app_frontend/features/support/presentation/pages/live_support_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isLiked = false;
  bool isSaved = false;

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/images/logo.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'İzge App',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              margin: const EdgeInsets.all(24),
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB49ckSgVb_PwyzbxKjPFCQNYjgMamIAGRLzCMuXvYcPK87dqz0b4hkfufk5BPzvaiGPoldUSIj0qWWDQCjJS6Ftb6UsXdelupjzXqyqvTAhCBv65YAuRemGVNrBSSiMKnm9MA0AGY__bK4qt58u9fT38auVYzYayu8RCKaC4VL4exDM4KYmila6jEMe_Vgy_pLVKon9Kce4KV0IALhgpk3qAd0VXFEe2f2mCqvz4pMJFiNcm-M7IHi4zCxGnTTaT4ztntzp1NcKBJI',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.surface.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'DUYURU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        '24 Ekim 2023',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Yıllık Genel Kurul Toplantısı ve Yeni Dönem Hedefleri',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),

                  // Actions Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ActionButton(
                            icon: isLiked ? Icons.favorite : Icons.favorite_border, 
                            color: isLiked ? AppColors.accent : AppColors.textSecondary,
                            label: isLiked ? 'Beğenildi' : 'Beğen',
                            onTap: _toggleLike,
                          ),
                          _ActionButton(
                            icon: isSaved ? Icons.bookmark : Icons.bookmark_border, 
                            color: isSaved ? AppColors.accent : AppColors.textSecondary,
                            label: isSaved ? 'Kaydedildi' : 'Kaydet',
                            onTap: _toggleSave,
                          ),
                          _ActionButton(
                            icon: Icons.share, 
                            label: 'Paylaş',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Paylaşım menüsü açılıyor...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Article Body
                  Text(
                    'Değerli Üyelerimiz,',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(
                          text: 'Derneğimizin 2023 yılı Olağan Genel Kurul Toplantısı, yönetim kurulumuzun aldığı karar doğrultusunda geniş bir katılımla gerçekleştirildi. ',
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Geçtiğimiz dönemin faaliyet raporlarının detaylı bir şekilde değerlendirildiği toplantıda, derneğimizin finansal durumu ve hayata geçirilen projelerin dernek amaçlarımıza katkıları tüm şeffaflığıyla üyelerimize sunuldu.',
                        ),
                      ],
                    ),
                  ),
                  
                  // Inline Image with Caption
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB49ckSgVb_PwyzbxKjPFCQNYjgMamIAGRLzCMuXvYcPK87dqz0b4hkfufk5BPzvaiGPoldUSIj0qWWDQCjJS6Ftb6UsXdelupjzXqyqvTAhCBv65YAuRemGVNrBSSiMKnm9MA0AGY__bK4qt58u9fT38auVYzYayu8RCKaC4VL4exDM4KYmila6jEMe_Vgy_pLVKon9Kce4KV0IALhgpk3qAd0VXFEe2f2mCqvz4pMJFiNcm-M7IHi4zCxGnTTaT4ztntzp1NcKBJI',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.2),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Genel kurul üyelerimiz toplantıda söz alarak görüşlerini paylaştılar.',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    'Yeni dönem hedeflerimiz kapsamında, özellikle gençlerimize yönelik eğitim burslarının artırılması, yerel yönetimlerle ortaklaşa yürütülecek çevre bilinci projelerine hız verilmesi ve dezavantajlı gruplar için sosyal destek programlarının genişletilmesi kararlaştırıldı. Kurumumuzun güvenilirliğini ve şeffaflığını her zaman ön planda tutarak, bu hedeflere ulaşmak için tüm gücümüzle çalışmaya devam edeceğiz.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  // Quote Block
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: AppColors.accent, width: 4)),
                    ),
                    child: Text(
                      '"Birlikte daha güçlü adımlar atarak, toplumsal fayda sağlama misyonumuzu her geçen gün daha da ileriye taşıyacağız. Tüm üyelerimize destekleri için teşekkür ederiz."',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),

                  Text(
                    'Toplantı tutanakları ve alınan kararların tam metnine uygulamamız içerisindeki \'Belgeler\' bölümünden ulaşabilirsiniz. Önümüzdeki süreçte gerçekleştirilecek etkinlikler ve gönüllülük faaliyetleri için bizi takip etmeye devam edin.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bottom Buttons
                  Container(
                    padding: const EdgeInsets.only(top: 24, bottom: 48),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Paylaşım menüsü açılıyor...')),
                            );
                          },
                          icon: Icon(Icons.share, color: Colors.white),
                          label: const Text('Haberi Paylaş', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceElevated,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                            );
                          },
                          icon: Icon(Icons.support_agent, color: AppColors.background),
                          label: Text('Canlı Desteğe Bağlan', style: TextStyle(color: AppColors.background, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.textSecondary, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color ?? AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
