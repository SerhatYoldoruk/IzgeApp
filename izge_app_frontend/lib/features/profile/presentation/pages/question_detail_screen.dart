import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class QuestionDetailScreen extends StatelessWidget {
  final String questionTitle;
  final String category;
  final String lastUpdated;

  const QuestionDetailScreen({
    super.key,
    this.questionTitle = 'Uygulama üzerinden nasıl talep oluşturabilirim?',
    this.category = 'Teknik Destek',
    this.lastUpdated = '2 gün önce',
  });

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
          'Soru Detayı',
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
            // Question Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: Color(0xFF7ADC75), width: 4)), // primary
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: AppColors.textSecondary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Son güncelleme: $lastUpdated',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('•', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated, // surface-container-high
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Detailed Answer Section
            Text(
              'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz. İşlemi tamamlamak için aşağıdaki adımları sırasıyla takip ediniz:',
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.6),
            ),
            SizedBox(height: 32),
            const Text(
              'Adım Adım Talep Oluşturma',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7ADC75)), // primary
            ),
            const SizedBox(height: 16),
            _buildOrderedList([
              'Ana sayfanın alt kısmında bulunan navigasyon barından **Talepler** sekmesine dokunun.',
              'Ekranın sağ alt köşesinde yer alan **+ (Yeni Talep Ekle)** butonuna tıklayın.',
              'Açılan formda talebinizin kategorisini seçin (Örn: Çevre Düzenlemesi, Teknik Sorun, Öneri vb.).',
              'Talebinizin başlığını ve detaylı açıklamasını ilgili alanlara girin. *Not: Açıklamanızı ne kadar detaylı yazarsanız, sürecin o kadar hızlı ilerlemesini sağlarsınız.*',
              'Eğer talebinizle ilgili bir fotoğraf veya belge eklemek isterseniz, "Dosya Ekle" ikonuna tıklayarak cihazınızdan görsel yükleyebilirsiniz.',
              'Son olarak, formun altındaki **"Talebi Gönder"** butonuna basarak işleminizi tamamlayın.',
            ]),
            const SizedBox(height: 32),
            const Text(
              'Talep Durumunu Takip Etme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7ADC75)), // primary
            ),
            const SizedBox(height: 16),
            Text(
              'Talebinizi oluşturduktan sonra, "Talepler" sekmesi altındaki "Geçmiş Taleplerim" listesinden sürecin hangi aşamada olduğunu takip edebilirsiniz. Talebiniz onaylandığında, işleme alındığında ve çözümlendiğinde size anlık bildirim (push notification) olarak bilgi verilecektir.\n\nEğer oluşturduğunuz bir talebi iptal etmek isterseniz, talep detay sayfasına girerek "Talebi İptal Et" seçeneğini kullanabilirsiniz. Ancak işleme alınmış talepler iptal edilememektedir.',
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.6),
            ),
            SizedBox(height: 48),

            // Helpful Feedback Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // outline-variant
              ),
              child: Column(
                children: [
                  Text(
                    'Bu makale yardımcı oldu mu?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_up, color: AppColors.textSecondary, size: 20),
                          label: Text('Evet', style: TextStyle(color: AppColors.textPrimary)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.border), // outline-variant
                            backgroundColor: AppColors.border, // surface-container-highest
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_down, color: AppColors.textSecondary, size: 20),
                          label: Text('Hayır', style: TextStyle(color: AppColors.textPrimary)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.border), // outline-variant
                            backgroundColor: AppColors.border, // surface-container-highest
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildOrderedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        int idx = entry.key + 1;
        String text = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$idx. ', style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.6, fontWeight: FontWeight.bold)),
              Expanded(
                child: _buildRichText(text),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Simple parser to render **bold** and *italic* text from markdown strings
  Widget _buildRichText(String text) {
    // This is a very simplified markdown parser just for the design elements.
    List<TextSpan> spans = [];
    
    // Fallback if regex gets too complex, just render normal text for now except for known patterns
    // We can use a simple replace approach if needed, but since it's hardcoded data, let's just use TextSpan.
    
    // Instead of full markdown parsing, we will just manually construct spans for the hardcoded text
    if (text.contains('**Talepler**')) {
      spans = const [
        TextSpan(text: 'Ana sayfanın alt kısmında bulunan navigasyon barından '),
        TextSpan(text: 'Talepler', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: ' sekmesine dokunun.'),
      ];
    } else if (text.contains('**+ (Yeni Talep Ekle)**')) {
      spans = const [
        TextSpan(text: 'Ekranın sağ alt köşesinde yer alan '),
        TextSpan(text: '+ (Yeni Talep Ekle)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: ' butonuna tıklayın.'),
      ];
    } else if (text.contains('*Not: Açıklamanızı')) {
      spans = const [
        TextSpan(text: 'Talebinizin başlığını ve detaylı açıklamasını ilgili alanlara girin. '),
        TextSpan(text: 'Not: Açıklamanızı ne kadar detaylı yazarsanız, sürecin o kadar hızlı ilerlemesini sağlarsınız.', style: TextStyle(fontStyle: FontStyle.italic)),
      ];
    } else if (text.contains('**"Talebi Gönder"**')) {
      spans = const [
        TextSpan(text: 'Son olarak, formun altındaki '),
        TextSpan(text: '"Talebi Gönder"', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: ' butonuna basarak işleminizi tamamlayın.'),
      ];
    } else {
      spans = [TextSpan(text: text)];
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.6),
        children: spans,
      ),
    );
  }
}
