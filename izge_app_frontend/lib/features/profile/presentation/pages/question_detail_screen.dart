import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

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
        title: Text(
          'Soru Detayı'.tr(),
          style: const TextStyle(
            fontSize: 20,
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
                    questionTitle.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Icon(Icons.schedule, color: AppColors.textSecondary, size: 18),
                      Text(
                        '${'Son Güncelleme'.tr()}: ${lastUpdated.tr()}',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text('•', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated, // surface-container-high
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category.tr(),
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
              'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz. İşlemi tamamlamak için aşağıdaki adımları sırasıyla takip ediniz:'.tr(),
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.6),
            ),
            SizedBox(height: 32),
            Text(
              'Adım Adım Talep Oluşturma'.tr(),
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
            Text(
              'Talep Durumunu Takip Etme'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7ADC75)), // primary
            ),
            const SizedBox(height: 16),
            Text(
              'Talebinizi oluşturduktan sonra, "Talepler" sekmesi altındaki "Geçmiş Taleplerim" listesinden sürecin hangi aşamada olduğunu takip edebilirsiniz. Talebiniz onaylandığında, işleme alındığında ve çözümlendiğinde size anlık bildirim (push notification) olarak bilgi verilecektir.\n\nEğer oluşturduğunuz bir talebi iptal etmek isterseniz, talep detay sayfasına girerek "Talebi İptal Et" seçeneğini kullanabilirsiniz. Ancak işleme alınmış talepler iptal edilememektedir.'.tr(),
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
                    'Bu makale yardımcı oldu mu?'.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_up, color: AppColors.textSecondary, size: 20),
                          label: Text('Evet'.tr(), style: TextStyle(color: AppColors.textPrimary)),
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
                          label: Text('Hayır'.tr(), style: TextStyle(color: AppColors.textPrimary)),
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
    
    final isEn = LanguageController.instance.isEnglish;
    
    // Instead of full markdown parsing, we will just manually construct spans for the hardcoded text
    if (text.contains('**Talepler**')) {
      spans = [
        TextSpan(text: isEn ? 'Tap the ' : 'Ana sayfanın alt kısmında bulunan navigasyon barından '),
        TextSpan(text: isEn ? 'Requests' : 'Talepler', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: isEn ? ' tab from the navigation bar at the bottom of the home page.' : ' sekmesine dokunun.'),
      ];
    } else if (text.contains('**+ (Yeni Talep Ekle)**')) {
      spans = [
        TextSpan(text: isEn ? 'Click the ' : 'Ekranın sağ alt köşesinde yer alan '),
        TextSpan(text: isEn ? '+ (Add New Request)' : '+ (Yeni Talep Ekle)', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: isEn ? ' button in the bottom right corner of the screen.' : ' butonuna tıklayın.'),
      ];
    } else if (text.contains('*Not: Açıklamanızı')) {
      spans = [
        TextSpan(text: isEn ? 'Enter the title and detailed description of your request in the relevant fields. ' : 'Talebinizin başlığını ve detaylı açıklamasını ilgili alanlara girin. '),
        TextSpan(text: isEn ? 'Note: The more detailed your description, the faster the process will progress.' : 'Not: Açıklamanızı ne kadar detaylı yazarsanız, sürecin o kadar hızlı ilerlemesini sağlarsınız.', style: const TextStyle(fontStyle: FontStyle.italic)),
      ];
    } else if (text.contains('**"Talebi Gönder"**')) {
      spans = [
        TextSpan(text: isEn ? 'Finally, click the ' : 'Son olarak, formun altındaki '),
        TextSpan(text: isEn ? '"Submit Request"' : '"Talebi Gönder"', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ADC75))),
        TextSpan(text: isEn ? ' button at the bottom of the form to complete your transaction.' : ' butonuna basarak işleminizi tamamlayın.'),
      ];
    } else if (text.contains('kategorisini seçin')) {
      spans = [
        TextSpan(text: isEn 
            ? 'Select the category of your request in the form that opens (e.g. Landscaping, Technical Issue, Suggestion, etc.).' 
            : 'Açılan formda talebinizin kategorisini seçin (Örn: Çevre Düzenlemesi, Teknik Sorun, Öneri vb.).'),
      ];
    } else if (text.contains('Dosya Ekle')) {
      spans = [
        TextSpan(text: isEn 
            ? 'If you want to add a photo or document related to your request, you can upload an image from your device by clicking the "Add File" icon.' 
            : 'Eğer talebinizle ilgili bir fotoğraf veya belge eklemek isterseniz, "Dosya Ekle" ikonuna tıklayarak cihazınızdan görsel yükleyebilirsiniz.'),
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
