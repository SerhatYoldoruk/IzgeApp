// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

void main() async {
  const String url = 'https://kfmncwtbtmqjfbmxbdhs.supabase.co';
  const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmbW5jd3RidG1xamZibXhiZGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4NjUxMzEsImV4cCI6MjA5MDQ0MTEzMX0.tpx0g8g8l-0auEOt3Hq42b58amTf0RocLg3fPXrz5e0';

  final supabase = SupabaseClient(url, anonKey);
  
  try {
    final email = 'admin_test_${Uuid().v4().substring(0,8)}@test.com';
    await supabase.auth.signUp(
      email: email,
      password: 'password123',
    );
    print('Dummy user created and logged in: $email');
  } catch (e) {
    print('Failed to sign up (maybe RLS blocks insert anyway?): $e');
  }

  final newCards = [
    {
      'title': 'Deprem Anında Yapılması Gerekenler',
      'summary': 'Afet anında özel gereksinimli bireylerin ve ailelerinin izlemesi gereken hayati adımlar.',
      'content': 'Özel gereksinimli bireyler ve aileleri için deprem anında yapılması gerekenler:\\n\\n1. Sakin kalın ve "Çök, Kapan, Tutun" pozisyonunu alın.\\n2. Önceden belirlenmiş güvenli alanlara geçin.\\n3. Özel cihazlar veya tekerlekli sandalye kullanılıyorsa tekerlekleri kilitleyin.\\n4. Görme veya işitme engelli bireyler için önceden pratik yapılmış olan uyarılara dikkat edin.',
      'category': 'genel',
      'color_hex': '#D32F2F', // Kırmızı
      'icon_name': 'warning',
      'sort_order': 4,
      'is_active': true,
    },
    {
      'title': 'Afet Çantası Hazırlığı',
      'summary': 'Özel gereksinimli bireyler için afet çantasında bulunması gereken zorunlu eşyalar ve medikal malzemeler.',
      'content': 'Afet çantanızda herkes için gerekli olan standart eşyaların yanı sıra şunları da bulundurun:\\n\\n- Düzenli kullanılan ilaçlar (en az 1 haftalık yedek).\\n- Yedek gözlük, işitme cihazı pili vb. medikal cihaz yedekleri.\\n- Tıbbi raporların ve önemli evrakların su geçirmez bir poşette kopyaları.\\n- Bireyin kendini rahat hissetmesini sağlayacak rahatlatıcı bir eşya (oyuncak, battaniye vb.).',
      'category': 'genel',
      'color_hex': '#1976D2', // Mavi
      'icon_name': 'medical_services',
      'sort_order': 5,
      'is_active': true,
    },
    {
      'title': 'Engelli Bireylerle Doğru İletişim',
      'summary': 'Görme, işitme ve zihinsel engelli bireylerle iletişim kurarken dikkat edilmesi gereken temel yaklaşımlar.',
      'content': 'İletişim sırasında dikkat edilmesi gerekenler:\\n\\n- Görme Engelli Bireyler: Konuşmaya başlamadan önce kendinizi tanıtın. Dokunmadan önce haber verin ve yönlendirirken kolunuzdan tutmasını teklif edin.\\n- İşitme Engelli Bireyler: Yüz yüze, göz teması kurarak açık ve anlaşılır bir dille konuşun. Gerekirse yazarak veya jest-mimiklerle iletişimi destekleyin.\\n- Zihinsel Engelli Bireyler: Basit ve kısa cümleler kurun. Sabırlı olun ve anlaması için zaman tanıyın.',
      'category': 'iletisim',
      'color_hex': '#F57C00', // Turuncu
      'icon_name': 'diversity_3',
      'sort_order': 6,
      'is_active': true,
    }
  ];

  print('Kartlar ekleniyor...');
  try {
    for (var card in newCards) {
      await supabase.from('info_cards').insert(card);
      print('${card['title']} eklendi.');
    }
    print('İşlem başarıyla tamamlandı!');
  } catch (e) {
    print('Hata oluştu: $e');
  }
}
