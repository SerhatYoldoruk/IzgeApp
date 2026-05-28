import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  LanguageController._();

  static final LanguageController instance = LanguageController._();

  String _currentLanguage = 'tr';

  String get currentLanguage => _currentLanguage;

  bool get isTurkish => _currentLanguage == 'tr';
  bool get isEnglish => _currentLanguage == 'en';

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('languageCode') ?? 'tr';
    } catch (_) {
      _currentLanguage = 'tr';
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage == languageCode) return;
    _currentLanguage = languageCode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
    } catch (_) {}
  }

  String translate(String key) {
    if (_currentLanguage == 'en') {
      return _enTranslations[key] ?? key;
    }
    return _trTranslations[key] ?? key;
  }

  static final Map<String, String> _trTranslations = {
    // Tab & Drawer & Navigation
    'Anasayfa': 'Anasayfa',
    'Haberler': 'Haberler',
    'Talepler': 'Talepler',
    'Anketler': 'Anketler',
    'Profil': 'Profil',
    'Profilim': 'Profilim',
    'Bağış Yap': 'Bağış Yap',
    'Bağış Geçmişi': 'Bağış Geçmişi',
    'Ayarlar': 'Ayarlar',
    'Dernek Hakkında': 'Dernek Hakkında',
    'Yardım Merkezi': 'Yardım Merkezi',
    'Çıkış Yap': 'Çıkış Yap',
    'DİL': 'DİL',
    'TEMA': 'TEMA',
    'AKTİVİTEM': 'AKTİVİTEM',
    'Beğenilenler': 'Beğenilenler',
    'Kaydedilenler': 'Kaydedilenler',
    'Etkinlikler': 'Etkinlikler',
    'KAYDEDİLENLER': 'KAYDEDİLENLER',
    'Kaydedilen Haberler': 'Kaydedilen Haberler',
    'Favori Etkinlikler': 'Favori Etkinlikler',
    'DESTEK ÖZETİ': 'DESTEK ÖZETİ',
    'Bağış Geçmişim': 'Bağış Geçmişim',

    // Home
    'Merhaba': 'Merhaba',
    'Bekleyen 1 talebiniz var.': 'Bekleyen 1 talebiniz var.',
    'Talep Aç': 'Talep Aç',
    'Destek': 'Destek',
    'Öne Çıkanlar': 'Öne Çıkanlar',
    'Hepsini Gör': 'Hepsini Gör',
    'Tümünü Gör': 'Tümünü Gör',
    'Yaklaşan Etkinlikler': 'Yaklaşan Etkinlikler',
    'Aktif anket bulunmuyor': 'Aktif anket bulunmuyor',
    'Bizi Takip Edin': 'Bizi Takip Edin',
    'Size yardımcı olmak için buradayız. Hemen sohbete başlayın.':
        'Size yardımcı olmak için buradayız. Hemen sohbete başlayın.',
    'Bize Yazın': 'Bize Yazın',
    'Henüz talep bulunmuyor': 'Henüz talep bulunmuyor',
    'Yaklaşan etkinlik bulunmuyor': 'Yaklaşan etkinlik bulunmuyor',
    'ETKİNLİK': 'ETKİNLİK',
    'DUYURU': 'DUYURU',
    'Engelsiz Yaşam Buluşması': 'Engelsiz Yaşam Buluşması',
    'Yeni Rehabilitasyon Merkezi': 'Yeni Rehabilitasyon Merkezi',

    // Event Detail Screen
    'Etkinlik Detayı': 'Etkinlik Detayı',
    'Seminer': 'Seminer',
    '12 Haziran 2024': '12 Haziran 2024',
    'Çarşamba': 'Çarşamba',
    'Başlangıç': 'Başlangıç',
    'Kültür Merkezi': 'Kültür Merkezi',
    'Ankara': 'Ankara',
    'ORGANİZATÖR': 'ORGANİZATÖR',
    'Etkinlik Hakkında': 'Etkinlik Hakkında',
    'Etkinliğe Katıl': 'Etkinliğe Katıl',
    'Etkinlik Kaydı': 'Etkinlik Kaydı',
    'Tekerlekli Sandalye Erişimi': 'Tekerlekli Sandalye Erişimi',
    'Rampa veya asansör ihtiyacım var': 'Rampa veya asansör ihtiyacım var',
    'İşaret Dili Çevirmeni': 'İşaret Dili Çevirmeni',
    'Refakatçi İle Katılacağım': 'Refakatçi İle Katılacağım',
    'Kaydı Tamamla': 'Kaydı Tamamla',

    // Notifications Screen
    'Bildirimler': 'Bildirimler',
    'Yeni Bildiriminiz Yok': 'Yeni Bildiriminiz Yok',
    'Dernekten veya katıldığınız etkinliklerden gelecek güncel bildirimler burada listelenecektir.':
        'Dernekten veya katıldığınız etkinliklerden gelecek güncel bildirimler burada listelenecektir.',
    'Ana Sayfaya Dön': 'Ana Sayfaya Dön',

    // Events Screen
    'Etkinlik Takvimi': 'Etkinlik Takvimi',

    // Profile Linked Accounts
    'Bağla': 'Bağla',

    // Event Detail Screen - long description texts (TR)
    'Engelli bireylerin sosyal hayata katılımını desteklemek ve farkındalık yaratmak amacıyla düzenlediğimiz "Engelsiz Yaşam Buluşması"nda sizleri de aramızda görmekten mutluluk duyarız.':
        'Engelli bireylerin sosyal hayata katılımını desteklemek ve farkındalık yaratmak amacıyla düzenlediğimiz "Engelsiz Yaşam Buluşması"nda sizleri de aramızda görmekten mutluluk duyarız.',
    'Bu özel etkinlikte, alanında uzman konuşmacılarımızın sunumları, atölye çalışmaları ve interaktif paneller yer alacaktır. Birlikte daha güçlü, erişilebilir ve kapsayıcı bir toplum inşa etmek için fikir alışverişinde bulunacağız.':
        'Bu özel etkinlikte, alanında uzman konuşmacılarımızın sunumları, atölye çalışmaları ve interaktif paneller yer alacaktır. Birlikte daha güçlü, erişilebilir ve kapsayıcı bir toplum inşa etmek için fikir alışverişinde bulunacağız.',
    'Lütfen varsa özel gereksinimlerinizi belirtin. Bu bilgiler, etkinliği sizin için daha erişilebilir hale getirmemize yardımcı olacaktır.':
        'Lütfen varsa özel gereksinimlerinizi belirtin. Bu bilgiler, etkinliği sizin için daha erişilebilir hale getirmemize yardımcı olacaktır.',

    // Event Success Screen (TR)
    'Katılım Onayı': 'Katılım Onayı',
    'Kaydınız başarıyla oluşturulmuştur. Etkinlik detayları ve güncellemeler için takipte kalın.':
        'Kaydınız başarıyla oluşturulmuştur. Etkinlik detayları ve güncellemeler için takipte kalın.',
    'Etkinlik': 'Etkinlik',
    'Tarih': 'Tarih',
    'Konum': 'Konum',
    'Etkinliklerime Git': 'Etkinliklerime Git',
    'Anasayfaya Dön': 'Anasayfaya Dön',

    // Settings & Language Screen
    'Genel': 'Genel',
    'Bildirim Ayarları': 'Bildirim Ayarları',
    'Dil Tercihi': 'Dil Tercihi',
    'Karanlık Mod': 'Karanlık Mod',
    'Güvenlik': 'Güvenlik',
    'Hesap Güvenliği': 'Hesap Güvenliği',
    'Gizlilik Politikası': 'Gizlilik Politikası',
    'Hakkımızda': 'Hakkımızda',
    'Uygulamayı kullanmak istediğiniz dili seçin.':
        'Uygulamayı kullanmak istediğiniz dili seçin.',
    'Kaydet': 'Kaydet',

    // Roles
    'Gönüllü Üye': 'Gönüllü Üye',
    'Yönetici': 'Yönetici',
    'Moderatör': 'Moderatör',
    'Kurumsal Erişim': 'Kurumsal Erişim',

    // Profile
    'Kişisel Bilgiler': 'Kişisel Bilgiler',
    'Etkinlik Katılımlarım': 'Etkinlik Katılımlarım',
    'Taleplerim': 'Taleplerim',
    'BAĞLI HESAPLAR': 'BAĞLI HESAPLAR',

    // New Request
    'Dosya Kaynağı Seçin': 'Dosya Kaynağı Seçin',
    'Kamera': 'Kamera',
    'Galeri': 'Galeri',
    'Dosyalar': 'Dosyalar',
    'İhtiyacınızı bize bildirin, size en kısa sürede yardımcı olalım.':
        'İhtiyacınızı bize bildirin, size en kısa sürede yardımcı olalım.',
    'Talep Türü': 'Talep Türü',
    'Lütfen bir tür seçin': 'Lütfen bir tür seçin',
    'İlaç Yardımı': 'İlaç Yardımı',
    'Eğitim Desteği': 'Eğitim Desteği',
    'Psikolojik Destek': 'Psikolojik Destek',
    'Talep Detayı': 'Talep Detayı',
    'Talebinizi buraya detaylı bir şekilde yazınız...':
        'Talebinizi buraya detaylı bir şekilde yazınız...',
    'Ek Dosya (İsteğe Bağlı)': 'Ek Dosya (İsteğe Bağlı)',
    'Dosya Ekle': 'Dosya Ekle',
    'Talebiniz başarıyla gönderildi.': 'Talebiniz başarıyla gönderildi.',
    'Talep Gönder': 'Talep Gönder',

    // News
    'Haberler ve Duyurular': 'Haberler ve Duyurular',
    'Dernekten en güncel haberler': 'Dernekten en güncel haberler',
    'Haberlerde ara...': 'Haberlerde ara...',
    'Tümü': 'Tümü',
    'Duyurular': 'Duyurular',
    'Projeler': 'Projeler',
    'Haber Bulunamadı': 'Haber Bulunamadı',
    'Aradığınız kriterlere uygun haber veya duyuru bulunmuyor. Farklı bir arama yapmayı deneyebilirsiniz.':
        'Aradığınız kriterlere uygun haber veya duyuru bulunmuyor. Farklı bir arama yapmayı deneyebilirsiniz.',
    'Tüm Haberleri Gör': 'Tüm Haberleri Gör',
    'Devamını Oku': 'Devamını Oku',
    'Yükleniyor...': 'Yükleniyor...',
    'Daha Fazla Yükle': 'Daha Fazla Yükle',

    // Requests
    'Henüz Bir Talep Oluşturmadınız': 'Henüz Bir Talep Oluşturmadınız',
    'İhtiyaç duyduğunuz konularda talep oluşturarak\nbizden destek alabilirsiniz.':
        'İhtiyaç duyduğunuz konularda talep oluşturarak\nbizden destek alabilirsiniz.',
    'Yeni Talep': 'Yeni Talep',

    // Surveys
    'Aktif Anketler': 'Aktif Anketler',
    'Henüz oluşturulmuş bir anket yok.': 'Henüz oluşturulmuş bir anket yok.',
    'Şu anda aktif anket bulunmuyor.': 'Şu anda aktif anket bulunmuyor.',
    'Geçmiş Anketler': 'Geçmiş Anketler',
    'Geçmiş anket bulunmuyor.': 'Geçmiş anket bulunmuyor.',
    'Ankete Katıl': 'Ankete Katıl',
    'Sonuçlandı': 'Sonuçlandı',
    'Gün Kaldı': 'Gün Kaldı',
    'Devam Ediyor': 'Devam Ediyor',

    // Dynamic/Static Survey Fields
    'Dernek Faaliyetleri Anketi': 'Dernek Faaliyetleri Anketi',
    'Dernek faaliyetleri hakkında geri bildirimleriniz.':
        'Dernek faaliyetleri hakkında geri bildirimleriniz.',
    'Yeni Logo Tasarımı': 'Yeni Logo Tasarımı',
    'Dernek logosunun yeni tasarımı hakkında oylama.':
        'Dernek logosunun yeni tasarımı hakkında oylama.',
    'Yeni Dönem Eğitim Atölyesi Tercihleri':
        'Yeni Dönem Eğitim Atölyesi Tercihleri',
    'Değerli üyemiz, önümüzdeki çeyrekte açılacak olan ücretsiz eğitim atölyelerimizin odak noktasını belirlemek için görüşünüze ihtiyacımız var. Lütfen size en faydalı olacak alanı seçiniz.':
        'Değerli üyemiz, önümüzdeki çeyrekte açılacak olan ücretsiz eğitim atölyelerimizin odak noktasını belirlemek için görüşünüze ihtiyacımız var. Lütfen size en faydalı olacak alanı seçiniz.',
    'Haftalık Memnuniyet Anketi': 'Haftalık Memnuniyet Anketi',
    'TOPLULUK GELİŞİMİ': 'TOPLULUK GELİŞİMİ',
    '1,248 Katılım': '1,248 Katılım',
    'Son 2 Gün': 'Son 2 Gün',
    'Hangi alanda atölye açılmasını istersiniz?':
        'Hangi alanda atölye açılmasını istersiniz?',
    'Yalnızca bir seçenek işaretleyebilirsiniz.':
        'Yalnızca bir seçenek işaretleyebilirsiniz.',
    'Yazılım & Teknoloji': 'Yazılım & Teknoloji',
    'Kodlama, Veri Analizi, Yapay Zeka': 'Kodlama, Veri Analizi, Yapay Zeka',
    'Sürdürülebilirlik & Çevre': 'Sürdürülebilirlik & Çevre',
    'İklim Krizi, İleri Dönüşüm, Ekoloji':
        'İklim Krizi, İleri Dönüşüm, Ekoloji',
    'Sanat & Tasarım': 'Sanat & Tasarım',
    'Grafik Tasarım, Seramik, Fotoğrafçılık':
        'Grafik Tasarım, Seramik, Fotoğrafçılık',
    'Girişimcilik & Liderlik': 'Girişimcilik & Liderlik',
    'Proje Yönetimi, İletişim Becerileri':
        'Proje Yönetimi, İletişim Becerileri',
    'Kaydediliyor...': 'Kaydediliyor...',
    'Yanıtınız Alındı': 'Yanıtınız Alındı',
    'Yanıtı Gönder': 'Yanıtı Gönder',
    'Yanıtınız başarıyla kaydedildi.': 'Yanıtınız başarıyla kaydedildi.',
    'Anket Sonuçları': 'Anket Sonuçları',
    'Katılım': 'Katılım',
    '1,240 Kişi': '1,240 Kişi',
    'Durum': 'Durum',
    'Hizmet kalitemizden memnun musunuz?':
        'Hizmet kalitemizden memnun musunuz?',
    'Çok Memnunum': 'Çok Memnunum',
    'Memnunum': 'Memnunum',
    'Kararsızım': 'Kararsızım',
    'Yeni etkinlik önerilerinizi bizimle paylaşır mısınız?':
        'Yeni etkinlik önerilerinizi bizimle paylaşır mısınız?',
    'Sosyal Etkinlik': 'Sosyal Etkinlik',
    'Spor': 'Spor',
    'Diğer Anketlere Göz At': 'Diğer Anketlere Göz At',

    // Specific Database Active Surveys from User Screenshot
    'Uygulamanın yeni premium tasarımını nasıl buldunuz?':
        'Uygulamanın yeni premium tasarımını nasıl buldunuz?',
    'Siz değerli kullanıcılarımızın geri bildirimleri bizim için çok önemli.':
        'Siz değerli kullanıcılarımızın geri bildirimleri bizim için çok önemli.',
    'Hangi afet eğitimlerine daha çok ağırlık verilmeli?':
        'Hangi afet eğitimlerine daha çok ağırlık verilmeli?',
    'Gelecek ay planlanacak yüz yüze eğitim seminerlerinin ana konusunu hep birlikte belirliyoruz.':
        'Gelecek ay planlanacak yüz yüze eğitim seminerlerinin ana konusunu hep birlikte belirliyoruz.',

    // Personal Information Screen
    'Fotoğrafı Değiştir': 'Fotoğrafı Değiştir',
    'Bilgileriniz başarıyla kaydedildi!': 'Bilgileriniz başarıyla kaydedildi!',
    'Adınız Soyadınız': 'Adınız Soyadınız',
    'E-posta': 'E-posta',
    'E-posta adresiniz': 'E-posta adresiniz',
    'Telefon': 'Telefon',
    'Telefon numaranız': 'Telefon numaranız',
    'Adres': 'Adres',
    'Açık adresiniz...': 'Açık adresiniz...',

    // Rights & Obligations Screen
    'Haklar ve Yükümlülükler': 'Haklar ve Yükümlülükler',
    'Üye Hakları ve Sorumlulukları': 'Üye Hakları ve Sorumlulukları',
    'Dernek tüzüğüne göre, yönetim kurulu ve normal üyelerin temel hak ve yükümlülükleri aşağıda özetlenmiştir.':
        'Dernek tüzüğüne göre, yönetim kurulu ve normal üyelerin temel hak ve yükümlülükleri aşağıda özetlenmiştir.',
    'Temel Haklar': 'Temel Haklar',
    'Genel Kurul ve Oy Hakkı': 'Genel Kurul ve Oy Hakkı',
    'Tüm asil üyeler genel kurula katılma, söz alma ve dernek organları için oy kullanma hakkına sahiptir.':
        'Tüm asil üyeler genel kurula katılma, söz alma ve dernek organları için oy kullanma hakkına sahiptir.',
    'Bilgi Edinme': 'Bilgi Edinme',
    'Üyeler, derneğin faaliyetleri, mali durumu ve alınan kararlar hakkında düzenli olarak bilgilendirilme hakkına sahiptir.':
        'Üyeler, derneğin faaliyetleri, mali durumu ve alınan kararlar hakkında düzenli olarak bilgilendirilme hakkına sahiptir.',
    'Yükümlülükler': 'Yükümlülükler',
    'Tüzüğe Uygunluk': 'Tüzüğe Uygunluk',
    'Her üye dernek tüzüğüne, genel kurul ve yönetim kurulu kararlarına uymakla yükümlüdür.':
        'Her üye dernek tüzüğüne, genel kurul ve yönetim kurulu kararlarına uymakla yükümlüdür.',
    'Aidat Sorumluluğu': 'Aidat Sorumluluğu',
    'Üyeler, genel kurul tarafından belirlenen yıllık üyelik aidatlarını zamanında ödemekle yükümlüdür. Aksi halde üyelik askıya alınabilir.':
        'Üyeler, genel kurul tarafından belirlenen yıllık üyelik aidatlarını zamanında ödemekle yükümlüdür. Aksi halde üyelik askıya alınabilir.',
    'Dernek İtibarını Koruma': 'Dernek İtibarını Koruma',
    'Üyeler, derneğin vizyon ve misyonuna aykırı davranışlardan kaçınmalı ve derneğin itibarını zedeleyici faaliyetlerde bulunmamalıdır.':
        'Üyeler, derneğin vizyon ve misyonuna aykırı davranışlardan kaçınmalı ve derneğin itibarını zedeleyici faaliyetlerde bulunmamalıdır.',
    'Detaylı Bilgi': 'Detaylı Bilgi',
    'Dernek tüzüğünün tamamına ve tüm hukuki detaylara mevzuat sayfasından ulaşabilirsiniz.':
        'Dernek tüzüğünün tamamına ve tüm hukuki detaylara mevzuat sayfasından ulaşabilirsiniz.',
    'Tüzüğü İndir': 'Tüzüğü İndir',

    // About Us Screen
    'İzge Derneği': 'İzge Derneği',
    'Toplum İçin Birlikte Büyüyoruz.': 'Toplum İçin Birlikte Büyüyoruz.',
    'Hikayemiz': 'Hikayemiz',
    'İzge Derneği, toplumsal dayanışmayı güçlendirmek ve dezavantajlı gruplara sürdürülebilir destek sağlamak amacıyla kuruldu. Bir avuç gönüllünün çabasıyla başlayan bu yolculuk, bugün binlerce hayata dokunan büyük bir aileye dönüştü. Amacımız, yardımlaşmayı şeffaf ve ulaşılabilir kılarak daha adil bir yarın inşa etmektir.':
        'İzge Derneği, toplumsal dayanışmayı güçlendirmek ve dezavantajlı gruplara sürdürülebilir destek sağlamak amacıyla kuruldu. Bir avuç gönüllünün çabasıyla başlayan bu yolculuk, bugün binlerce hayata dokunan büyük bir aileye dönüştü. Amacımız, yardımlaşmayı şeffaf ve ulaşılabilir kılarak daha adil bir yarın inşa etmektir.',
    'Vizyonumuz': 'Vizyonumuz',
    'Her bireyin temel haklarına erişebildiği, eşitlikçi ve dayanışma odaklı bir toplum modelini hayata geçirmek.':
        'Her bireyin temel haklarına erişebildiği, eşitlikçi ve dayanışma odaklı bir toplum modelini hayata geçirmek.',
    'Misyonumuz': 'Misyonumuz',
    'İhtiyaç sahipleri ile gönüllüleri güvenli bir platformda buluşturarak, yerel ve ulusal çapta kalıcı çözümler üretmek.':
        'İhtiyaç sahipleri ile gönüllüleri güvenli bir platformda buluşturarak, yerel ve ulusal çapta kalıcı çözümler üretmek.',
    'Değerlerimiz': 'Değerlerimiz',
    'Eşitlik': 'Eşitlik',
    'Erişilebilirlik': 'Erişilebilirlik',
    'Dayanışma': 'Dayanışma',
    'Şeffaflık': 'Şeffaflık',
    'Bizimle İletişime Geçin': 'Bizimle İletişime Geçin',
    'Merkez Mah. Güneş Sok. No:1 Ankara': 'Merkez Mah. Güneş Sok. No:1 Ankara',

    // --- My Event Participations (Etkinlik Katılımlarım) ---
    'Yaklaşan': 'Yaklaşan',
    'Geçmiş': 'Geçmiş',
    'YAKLAŞAN': 'YAKLAŞAN',
    'Engelsiz Sanat Atölyesi': 'Engelsiz Sanat Atölyesi',
    '25 Haziran, 14:00': '25 Haziran, 14:00',
    'Dernek Merkezi': 'Dernek Merkezi',
    'Gönüllü Oryantasyonu': 'Gönüllü Oryantasyonu',
    '30 Haziran, 10:00': '30 Haziran, 10:00',
    'Online (Zoom)': 'Online (Zoom)',
    'Katılım Onaylandı': 'Katılım Onaylandı',
    'Onay Bekleniyor': 'Onay Bekleniyor',
    'Erişilebilirlik Zirvesi 2023': 'Erişilebilirlik Zirvesi 2023',
    '15 Mayıs, 10:00': '15 Mayıs, 10:00',
    'İstanbul Kültür Merkezi': 'İstanbul Kültür Merkezi',
    'Katıldı': 'Katıldı',
    'Engelsiz Basketbol Turnuvası': 'Engelsiz Basketbol Turnuvası',
    '2 Nisan, 14:30': '2 Nisan, 14:30',
    'Atatürk Spor Kompleksi': 'Atatürk Spor Kompleksi',
    'Dijital Okuryazarlık Atölyesi': 'Dijital Okuryazarlık Atölyesi',
    '12 Mart, 19:00': '12 Mart, 19:00',

    // --- Past Requests (Geçmiş Talepler) ---
    'Geçmiş Talepler': 'Geçmiş Talepler',
    'İhtiyaç duyduğunuz konularda talep oluşturarak bizden destek alabilirsiniz.':
        'İhtiyaç duyduğunuz konularda talep oluşturarak bizden destek alabilirsiniz.',

    // --- Notification Settings (Bildirim Ayarları) ---
    'Uygulama içi ve anlık bildirim tercihlerinizi buradan yönetebilirsiniz.':
        'Uygulama içi ve anlık bildirim tercihlerinizi buradan yönetebilirsiniz.',
    'Genel Bildirimler': 'Genel Bildirimler',
    'Tüm anlık bildirimleri açıp kapatın.':
        'Tüm anlık bildirimleri açıp kapatın.',
    'Önemli güncellemeler ve haberler': 'Önemli güncellemeler ve haberler',
    'Yeni Etkinlikler': 'Yeni Etkinlikler',
    'Yaklaşan etkinlikler ve davetler': 'Yaklaşan etkinlikler ve davetler',
    'Talep Güncellemeleri': 'Talep Güncellemeleri',
    'Taleplerinizin durum değişiklikleri':
        'Taleplerinizin durum değişiklikleri',
    'Bağış Hatırlatıcıları': 'Bağış Hatırlatıcıları',
    'Düzenli bağış bildirimleri': 'Düzenli bağış bildirimleri',

    // --- Account Security (Hesap Güvenliği) ---
    'ŞİFRE İŞLEMLERİ': 'ŞİFRE İŞLEMLERİ',
    'GÜVENLİK KATMANLARI': 'GÜVENLİK KATMANLARI',
    'İki Faktörlü Doğrulama': 'İki Faktörlü Doğrulama',
    'Ekstra güvenlik şartları': 'Ekstra güvenlik şartları',
    'Biyometrik Giriş\n(FaceID/Parmak İzi)':
        'Biyometrik Giriş\n(FaceID/Parmak İzi)',
    'OTURUM YÖNETİMİ': 'OTURUM YÖNETİMİ',
    'Aktif Cihazlar': 'Aktif Cihazlar',
    'Bu Cihaz: iPhone 14 Pro': 'Bu Cihaz: iPhone 14 Pro',
    'HESAP İŞLEMLERİ': 'HESAP İŞLEMLERİ',
    'Bu işlem kalıcıdır': 'Bu işlem kalıcıdır',
    'Emin misiniz?': 'Emin misiniz?',
    'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem kalıcıdır ve geri alınamaz.':
        'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem kalıcıdır ve geri alınamaz.',
    'İptal': 'İptal',
    'Hesap silme talebiniz alınmıştır.': 'Hesap silme talebiniz alınmıştır.',

    // --- Active Devices (Aktif Cihazlar) ---
    'Hesabınıza erişimi olan tüm cihazlar burada listelenir.':
        'Hesabınıza erişimi olan tüm cihazlar burada listelenir.',
    'Oturumu Kapat': 'Oturumu Kapat',
    'cihazındaki oturumu kapatmak istediğinize emin misiniz?':
        'cihazındaki oturumu kapatmak istediğinize emin misiniz?',
    'Oturum başarıyla kapatıldı!': 'Oturum başarıyla kapatıldı!',
    'Kapat': 'Kapat',
    'Son görülme: Dün, 14:30': 'Son görülme: Dün, 14:30',
    'Son görülme: 3 gün önce': 'Son görülme: 3 gün önce',
    'İstanbul, TR': 'İstanbul, TR',
    'Ankara, TR': 'Ankara, TR',
    'İzmir, TR': 'İzmir, TR',
    'Şu an aktif': 'Şu an aktif',

    // --- Account Security Fixes ---
    'Şifre Değiştir': 'Şifre Değiştir',
    'Hesabımı Sil': 'Hesabımı Sil',

    // --- Donation History (Bağış Geçmişi) ---
    'Henüz Bağış Yapmadınız': 'Henüz Bağış Yapmadınız',
    'Derneğimize yapacağınız bağışlar burada listelenecektir. Destek olmak için bağış sayfasını ziyaret edebilirsiniz.':
        'Derneğimize yapacağınız bağışlar burada listelenecektir. Destek olmak için bağış sayfasını ziyaret edebilirsiniz.',

    // --- Change Password (Şifre Değiştir) ---
    'Hesap güvenliğiniz için şifrenizi güncel tutun.':
        'Hesap güvenliğiniz için şifrenizi güncel tutun.',
    'Mevcut Şifre': 'Mevcut Şifre',
    'Mevcut şifrenizi girin': 'Mevcut şifrenizi girin',
    'Yeni Şifre': 'Yeni Şifre',
    'Yeni şifrenizi belirleyin': 'Yeni şifrenizi belirleyin',
    'Şifre Gereksinimleri:': 'Şifre Gereksinimleri:',
    'En az 8 karakter': 'En az 8 karakter',
    'En az 1 rakam': 'En az 1 rakam',
    'En az 1 özel karakter': 'En az 1 özel karakter',
    'Yeni Şifre (Tekrar)': 'Yeni Şifre (Tekrar)',
    'Yeni şifrenizi doğrulayın': 'Yeni şifrenizi doğrulayın',
    'Güncelleniyor...': 'Güncelleniyor...',
    'Şifreyi Güncelle': 'Şifreyi Güncelle',
    'Şifreler eşleşmiyor!': 'Şifreler eşleşmiyor!',
    'Şifreniz başarıyla güncellendi!': 'Şifreniz başarıyla güncellendi!',

    // --- Help Center (Yardım Merkezi) ---
    'Size nasıl yardımcı\nolabiliriz?': 'Size nasıl yardımcı\nolabiliriz?',
    'Sorunuzu arayın (örn: bağış yapmak)':
        'Sorunuzu arayın (örn: bağış yapmak)',
    'Kategoriler': 'Kategoriler',
    'Üyelik İşlemleri': 'Üyelik İşlemleri',
    'Bağışlar': 'Bağışlar',
    'Sıkça Sorulan Sorular': 'Sıkça Sorulan Sorular',
    'Detaylı Oku': 'Detaylı Oku',
    'Aradığınızı bulamadınız mı?': 'Aradığınızı bulamadınız mı?',
    'Destek ekibimiz size yardımcı olmak için hazır. Hafta içi 09:00 - 18:00 arası canlı destek alabilirsiniz.':
        'Destek ekibimiz size yardımcı olmak için hazır. Hafta içi 09:00 - 18:00 arası canlı destek alabilirsiniz.',
    'Canlı Destek Başlat': 'Canlı Destek Başlat',
    'Uygulama üzerinden nasıl talep oluşturabilirim?':
        'Uygulama üzerinden nasıl talep oluşturabilirim?',
    'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz.':
        'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz.',
    'Derneğe nasıl üye olabilirim?': 'Derneğe nasıl üye olabilirim?',
    'Üyelik formunu \'Üyelik İşlemleri\' bölümünden doldurarak başvurunuzu iletebilirsiniz. Başvurunuz yönetim kurulu tarafından değerlendirilip size dönüş sağlanacaktır.':
        'Üyelik formunu \'Üyelik İşlemleri\' bölümünden doldurarak başvurunuzu iletebilirsiniz. Başvurunuz yönetim kurulu tarafından değerlendirilip size dönüş sağlanacaktır.',
    'Bağış makbuzuma nasıl ulaşabilirim?':
        'Bağış makbuzuma nasıl ulaşabilirim?',
    'Yaptığınız tüm bağışların elektronik makbuzlarına \'Bağışlar\' menüsü altındaki \'Geçmiş İşlemlerim\' sekmesinden ulaşabilir ve indirebilirsiniz.':
        'Yaptığınız tüm bağışların elektronik makbuzlarına \'Bağışlar\' menüsü altındaki \'Geçmiş İşlemlerim\' sekmesinden ulaşabilir ve indirebilirsiniz.',
    'Etkinliklere katılım ücretli mi?': 'Etkinliklere katılım ücretli mi?',
    'Derneğimizin düzenlediği etkinliklerin büyük çoğunluğu üyelerimize ücretsizdir. Ücretli olan özel etkinliklerde, etkinlik detay sayfasında bilet bilgisi açıkça belirtilmektedir.':
        'Derneğimizin düzenlediği etkinliklerin büyük çoğunluğu üyelerimize ücretsizdir. Ücretli olan özel etkinliklerde, etkinlik detay sayfasında bilet bilgisi açıkça belirtilmektedir.',

    // --- Privacy Policy (Gizlilik Politikası) ---
    'Son Güncelleme: 24 Ekim 2023': 'Son Güncelleme: 24 Ekim 2023',
    'İzge App olarak gizliliğinize önem veriyoruz. Bu Gizlilik Politikası, uygulamamızı ("İzge App") kullandığınızda kişisel verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklamaktadır. Hizmetlerimizi kullanarak, bu politikada belirtilen uygulamaları kabul etmiş olursunuz.':
        'İzge App olarak gizliliğinize önem veriyoruz. Bu Gizlilik Politikası, uygulamamızı ("İzge App") kullandığınızda kişisel verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklamaktadır. Hizmetlerimizi kullanarak, bu politikada belirtilen uygulamaları kabul etmiş olursunuz.',
    '1. Veri Toplama': '1. Veri Toplama',
    'Size daha iyi bir deneyim sunabilmek için çeşitli bilgiler topluyoruz. Bunlar şunları içerebilir:':
        'Size daha iyi bir deneyim sunabilmek için çeşitli bilgiler topluyoruz. Bunlar şunları içerebilir:',
    'Kişisel Bilgiler: ': 'Kişisel Bilgiler: ',
    'Hesap oluştururken sağladığınız ad, e-posta adresi, telefon numarası gibi bilgiler.':
        'Hesap oluştururken sağladığınız ad, e-posta adresi, telefon numarası gibi bilgiler.',
    'Kullanım Verileri: ': 'Kullanım Verileri: ',
    'Uygulama içindeki etkileşimleriniz, ziyaret ettiğiniz sayfalar ve tercihlerinize dair anonim veya kişiselleştirilmiş istatistikler.':
        'Uygulama içindeki etkileşimleriniz, ziyaret ettiğiniz sayfalar ve tercihlerinize dair anonim veya kişiselleştirilmiş istatistikler.',
    'Cihaz Bilgileri: ': 'Cihaz Bilgileri: ',
    'Kullandığınız cihazın modeli, işletim sistemi sürümü ve benzersiz cihaz tanımlayıcıları.':
        'Kullandığınız cihazın modeli, işletim sistemi sürümü ve benzersiz cihaz tanımlayıcıları.',
    '2. Veri Kullanımı': '2. Veri Kullanımı',
    'Toplanan veriler, İzge App deneyiminizi iyileştirmek temel amacıyla aşağıdaki şekillerde kullanılır:':
        'Toplanan veriler, İzge App deneyiminizi iyileştirmek temel amacıyla aşağıdaki şekillerde kullanılır:',
    'Hizmetlerimizi sağlamak, sürdürmek ve iyileştirmek.':
        'Hizmetlerimizi sağlamak, sürdürmek ve iyileştirmek.',
    'Talep ve anketlerinizi işleme koymak, size özel bildirimler göndermek.':
        'Talep ve anketlerinizi işleme koymak, size özel bildirimler göndermek.',
    'Kullanıcı güvenliğini sağlamak ve olası dolandırıcılık veya kötüye kullanımı önlemek.':
        'Kullanıcı güvenliğini sağlamak ve olası dolandırıcılık veya kötüye kullanımı önlemek.',
    'Yasal yükümlülüklerimizi yerine getirmek.':
        'Yasal yükümlülüklerimizi yerine getirmek.',
    '3. Çerezler ve İzleme': '3. Çerezler ve İzleme',
    'Uygulamamız, oturum yönetimi ve performans analizi için çeşitli teknik izleme yöntemleri kullanmaktadır. Bu veriler üçüncü taraf reklam ağlarıyla doğrudan paylaşılmaz. Cihaz ayarlarınızdan veri takibini sınırlandırma hakkına sahipsiniz.':
        'Uygulamamız, oturum yönetimi ve performans analizi için çeşitli teknik izleme yöntemleri kullanmaktadır. Bu veriler üçüncü taraf reklam ağlarıyla doğrudan paylaşılmaz. Cihaz ayarlarınızdan veri takibini sınırlandırma hakkına sahipsiniz.',
    '4. İletişim': '4. İletişim',
    'Bu Gizlilik Politikası veya verilerinizin işlenmesiyle ilgili sorularınız, endişeleriniz veya talepleriniz varsa, lütfen bizimle iletişime geçmekten çekinmeyin:':
        'Bu Gizlilik Politikası veya verilerinizin işlenmesiyle ilgili sorularınız, endişeleriniz veya talepleriniz varsa, lütfen bizimle iletişime geçmekten çekinmeyin:',

    // --- Membership Help (Üyelik İşlemleri) ---
    'Nasıl yardımcı olabiliriz?': 'Nasıl yardımcı olabiliriz?',
    'Adım adım üyelik başvuru süreci, gerekli belgeler ve onay aşamaları hakkında detaylı bilgi edinin.':
        'Adım adım üyelik başvuru süreci, gerekli belgeler ve onay aşamaları hakkında detaylı bilgi edinin.',
    'İletişim bilgilerinizi, adresinizi veya mesleki detaylarınızı profiliniz üzerinden nasıl güncelleyeceğinizi öğrenin.':
        'İletişim bilgilerinizi, adresinizi veya mesleki detaylarınızı profiliniz üzerinden nasıl güncelleyeceğinizi öğrenin.',
    'Yıllık üyelik aidat ödemeleri, makbuz talepleri ve geçmiş ödeme geçmişi sorgulama adımları.':
        'Yıllık üyelik aidat ödemeleri, makbuz talepleri ve geçmiş ödeme geçmişi sorgulama adımları.',
    'Üyeliğinizi dondurma veya tamamen iptal etme prosedürleri, yasal süreçler ve dikkat edilmesi gereken hususlar hakkında kapsamlı rehber.':
        'Üyeliğinizi dondurma veya tamamen iptal etme prosedürleri, yasal süreçler ve dikkat edilmesi gereken hususlar hakkında kapsamlı rehber.',

    // --- Donations Help (Bağışlar) ---
    'Bağış işlemleriniz, vergi süreçleri ve fonların kullanımı hakkında detaylı bilgilere buradan ulaşabilirsiniz.':
        'Bağış işlemleriniz, vergi süreçleri ve fonların kullanımı hakkında detaylı bilgilere buradan ulaşabilirsiniz.',
    'Makbuz talepleri ve vergi indirim süreçleri':
        'Makbuz talepleri ve vergi indirim süreçleri',
    'Aylık Bağışlar': 'Aylık Bağışlar',
    'Düzenli bağış başlatma, düzenleme ve iptali':
        'Düzenli bağış başlatma, düzenleme ve iptali',
    'Şeffaflık raporları ve güncel projelerimiz':
        'Şeffaflık raporları ve güncel projelerimiz',
    'Başka bir sorunuz mu var?': 'Başka bir sorunuz mu var?',
    'Destek ekibimiz tüm soru ve sorunlarınız için size yardımcı olmaya hazır.':
        'Destek ekibimiz tüm soru ve sorunlarınız için size yardımcı olmaya hazır.',

    // --- Requests Help (Talepler) ---
    'Taleplerinizle ilgili sıkça sorulan sorular ve rehberler.':
        'Taleplerinizle ilgili sıkça sorulan sorular ve rehberler.',
    'Mevcut taleplerinizin hangi aşamada olduğunu nasıl öğrenebilirsiniz?':
        'Mevcut taleplerinizin hangi aşamada olduğunu nasıl öğrenebilirsiniz?',
    'Sisteme yeni eklenen hizmet talebi kategorileri ve başvuru süreçleri.':
        'Sisteme yeni eklenen hizmet talebi kategorileri ve başvuru süreçleri.',
    'Sorun Giderme': 'Sorun Giderme',
    'Talep oluştururken hata alıyorsanız, belgeleriniz yüklenmiyorsa veya uygulamanın çökmesi durumunda izlenecek adımlar.':
        'Talep oluştururken hata alıyorsanız, belgeleriniz yüklenmiyorsa veya uygulamanın çökmesi durumunda izlenecek adımlar.',
    'Çözüm Rehberini İncele': 'Çözüm Rehberini İncele',
    'Tamamlanmış veya iptal edilmiş taleplerinizin arşivine erişim.':
        'Tamamlanmış veya iptal edilmiş taleplerinizin arşivine erişim.',

    // --- Technical Support (Teknik Destek) ---
    'Uygulama ile ilgili teknik sorunlarınızı çözmek için buradayız.':
        'Uygulama ile ilgili teknik sorunlarınızı çözmek için buradayız.',
    'Sorununuzu arayın (örn. giriş hatası)':
        'Sorununuzu arayın (örn. giriş hatası)',
    'Giriş Problemleri': 'Giriş Problemleri',
    'Şifremi unuttum, hesabıma erişemiyorum veya doğrulama kodu gelmiyor.':
        'Şifremi unuttum, hesabıma erişemiyorum veya doğrulama kodu gelmiyor.',
    'Hata Bildirimi': 'Hata Bildirimi',
    'Uygulama çöküyor, ekran donuyor veya beklenmedik bir hata mesajı alıyorum.':
        'Uygulama çöküyor, ekran donuyor veya beklenmedik bir hata mesajı alıyorum.',
    'Cihaz ve Sistem Uyumluluğu': 'Cihaz ve Sistem Uyumluluğu',
    'Uygulamanın sürümü, işletim sistemi gereksinimleri ve performans ayarları hakkında destek alın.':
        'Uygulamanın sürümü, işletim sistemi gereksinimleri ve performans ayarları hakkında destek alın.',
    'Bağlantı Sorunları': 'Bağlantı Sorunları',
    'İnternet bağlantısı hatası, veri senkronizasyonu veya yavaş yüklenme problemleri.':
        'İnternet bağlantısı hatası, veri senkronizasyonu veya yavaş yüklenme problemleri.',
    'Yukarıdaki kategorilere uymayan diğer tüm teknik sorunlar için destek talebi oluşturun.':
        'Yukarıdaki kategorilere uymayan diğer tüm teknik sorunlar için destek talebi oluşturun.',
    'Destek ekibimizle doğrudan iletişime geçerek detaylı yardım alabilirsiniz.':
        'Destek ekibimizle doğrudan iletişime geçerek detaylı yardım alabilirsiniz.',

    // --- Login Issues (Giriş Problemleri) ---
    'Hesabınıza erişimde yaşadığınız sorunları hızlıca çözmek için aşağıdaki adımları takip edebilirsiniz.':
        'Hesabınıza erişimde yaşadığınız sorunları hızlıca çözmek için aşağıdaki adımları takip edebilirsiniz.',
    'Şifremi Unuttum': 'Şifremi Unuttum',
    'Mevcut şifrenizi hatırlamıyorsanız, sisteme kayıtlı e-posta adresinizi kullanarak yeni bir şifre oluşturabilirsiniz.':
        'Mevcut şifrenizi hatırlamıyorsanız, sisteme kayıtlı e-posta adresinizi kullanarak yeni bir şifre oluşturabilirsiniz.',
    'Şifre Sıfırlama Bağlantısı Gönder': 'Şifre Sıfırlama Bağlantısı Gönder',
    'E-posta Doğrulama Kodu Gelmiyor': 'E-posta Doğrulama Kodu Gelmiyor',
    "Eğer doğrulama kodu gelen kutunuza düşmediyse, lütfen 'Gereksiz/Spam' klasörünü kontrol edin. Kodun süresi dolmuş olabilir.":
        "Eğer doğrulama kodu gelen kutunuza düşmediyse, lütfen 'Gereksiz/Spam' klasörünü kontrol edin. Kodun süresi dolmuş olabilir.",
    'Kodu Tekrar Gönder': 'Kodu Tekrar Gönder',
    'Hesabım Kilitlendi': 'Hesabım Kilitlendi',
    'Çok sayıda hatalı giriş denemesi nedeniyle hesabınız güvenlik amacıyla geçici olarak kilitlenmiştir. Güvenlik doğrulamasını geçerek hesabınızı açabilirsiniz.':
        'Çok sayıda hatalı giriş denemesi nedeniyle hesabınız güvenlik amacıyla geçerek hesabınızı açabilirsiniz.',
    'Kimlik Doğrulama Adımına Git': 'Kimlik Doğrulama Adımına Git',
    'Hâlâ sorun mu yaşıyorsunuz?': 'Hâlâ sorun mu yaşıyorsunuz?',
    'Destek ekibimiz size yardımcı olmaktan memnuniyet duyar.':
        'Destek ekibimiz size yardımcı olmaktan memnuniyet duyar.',
    'Destek Talebi Oluştur': 'Destek Talebi Oluştur',

    // --- Tax Receipts ---
    'Vergi Makbuzları': 'Vergi Makbuzları',
    'Makbuz Bulunamadı': 'Makbuz Bulunamadı',
    'Sistemimizde adınıza düzenlenmiş bir vergi makbuzu bulunmamaktadır. Yaptığınız bağışların makbuzlarını buradan takip edebilirsiniz.':
        'Sistemimizde adınıza düzenlenmiş bir vergi makbuzu bulunmamaktadır. Yaptığınız bağışların makbuzlarını buradan takip edebilirsiniz.',
    'Şimdi Bağış Yap': 'Şimdi Bağış Yap',

    // --- Monthly Donations ---
    'Aylık Bağışlarım': 'Aylık Bağışlarım',
    'Aylık Bağışınız Yok': 'Aylık Bağışınız Yok',
    'Henüz düzenli bir bağış talimatınız bulunmamaktadır. Düzenli bağış yaparak sürdürülebilir projelere destek olabilirsiniz.':
        'Henüz düzenli bir bağış talimatınız bulunmamaktadır. Düzenli bağış yaparak sürdürülebilir projelere destek olabilirsiniz.',
    'Düzenli Bağış Başlat': 'Düzenli Bağış Başlat',

    // --- Contact Support ---
    'Teknik Destek': 'Teknik Destek',
    'Destek Ekibine Ulaşın': 'Destek Ekibine Ulaşın',
    'Sorununuzu daha hızlı çözebilmemiz için lütfen aşağıdaki detayları doldurun.':
        'Sorununuzu daha hızlı çözebilmemiz için lütfen aşağıdaki detayları doldurun.',
    'Destek Konusu': 'Destek Konusu',
    'Bir konu seçin': 'Bir konu seçin',
    'Teknik Sorun': 'Teknik Sorun',
    'Bağış İşlemleri': 'Bağış İşlemleri',
    'Üyelik': 'Üyelik',
    'Diğer': 'Diğer',
    'Mesajınız': 'Mesajınız',
    'Sorununuzu buraya detaylıca yazabilirsiniz...':
        'Sorununuzu buraya detaylıca yazabilirsiniz...',
    'Ek (İsteğe Bağlı)': 'Ek (İsteğe Bağlı)',
    'Ekran görüntüsü yükle': 'Ekran görüntüsü yükle',
    'Mesajı Gönder': 'Mesajı Gönder',

    // --- How to Become Member ---
    'Nasıl Üye Olunur?': 'Nasıl Üye Olunur?',
    'Aramıza katılmak için aşağıdaki adımları takip ederek üyelik sürecinizi tamamlayabilirsiniz.':
        'Aramıza katılmak için aşağıdaki adımları takip ederek üyelik sürecinizi tamamlayabilirsiniz.',
    'Başvuru Formu': 'Başvuru Formu',
    'Sistem üzerinden dijital üyelik başvuru formunu eksiksiz ve doğru bilgilerle doldurun.':
        'Sistem üzerinden dijital üyelik başvuru formunu eksiksiz ve doğru bilgilerle doldurun.',
    'Belge Yükleme': 'Belge Yükleme',
    'Kimlik fotokopisi ve dernek tüzüğünce talep edilen ek belgelerinizi sisteme güvenle yükleyin.':
        'Kimlik fotokopisi ve dernek tüzüğünce talep edilen ek belgelerinizi sisteme güvenle yükleyin.',
    'Değerlendirme Süreci': 'Değerlendirme Süreci',
    'Yönetim kurulumuz başvurunuzu ve belgelerinizi inceler. Bu süreç uygulama üzerinden takip edilebilir.':
        'Yönetim kurulumuz başvurunuzu ve belgelerinizi inceler. Bu süreç uygulama üzerinden takip edilebilir.',
    'Üyelik Aktifleşmesi': 'Üyelik Aktifleşmesi',
    "Onay sonrası giriş aidatınızı uygulama içinden ödeyerek İzge App'in tüm özelliklerini kullanmaya başlayın.":
        "Onay sonrası giriş aidatınızı uygulama içinden ödeyerek İzge App'in tüm özelliklerini kullanmaya başlayın.",
    'Hemen Başvur': 'Hemen Başvur',
    'Başvuru formuna yönlendiriliyorsunuz...':
        'Başvuru formuna yönlendiriliyorsunuz...',

    // --- Update Info Help ---
    'Bilgilerimi Güncelleme': 'Bilgilerimi Güncelleme',
    'Hesap bilgilerinizi güncel tutmak, kurum içi iletişim ve operasyonların sağlıklı yürümesi için önemlidir.':
        'Hesap bilgilerinizi güncel tutmak, kurum içi iletişim ve operasyonların sağlıklı yürümesi için önemlidir.',
    'Kişisel Profil': 'Kişisel Profil',
    'Ad, soyad, telefon ve e-posta bilgilerinizi profil ayarları bölümünden dilediğiniz zaman değiştirebilirsiniz. Değişiklikler anında sisteme yansır.':
        'Ad, soyad, telefon ve e-posta bilgilerinizi profil ayarları bölümünden dilediğiniz zaman değiştirebilirsiniz. Değişiklikler anında sisteme yansır.',
    'Adres Bilgileri': 'Adres Bilgileri',
    'Gönüllülük faaliyetleri ve olası kargo gönderimleri için ikametgah adresinizin doğruluğu elzemdir. Birden fazla adres ekleyebilir, varsayılanı seçebilirsiniz.':
        'Gönüllülük faaliyetleri ve olası kargo gönderimleri için ikametgah adresinizin doğruluğu elzemdir. Birden fazla adres ekleyebilir, varsayılanı seçebilirsiniz.',
    'Evrak ve Belgeler': 'Evrak ve Belgeler',
    'Bağış makbuzları, KVKK onay formları veya kurum kimlik belgelerinizi dijital formatta yükleyerek arşivleyebilirsiniz.':
        'Bağış makbuzları, KVKK onay formları veya kurum kimlik belgelerinizi dijital formatta yükleyerek arşivleyebilirsiniz.',
    'Dikkat Edilmesi Gerekenler': 'Dikkat Edilmesi Gerekenler',
    'Bilgilerinizi güncellerken resmi kimliğinizdeki formatı kullanmaya özen gösterin.':
        'Bilgilerinizi güncellerken resmi kimliğinizdeki formatı kullanmaya özen gösterin.',
    'E-posta ve telefon numarası değişikliklerinde doğrulama kodu gönderilecektir.':
        'E-posta ve telefon numarası değişikliklerinde doğrulama kodu gönderilecektir.',
    'Hatalı girilen IBAN veya adres bilgileri, süreçlerde gecikmelere yol açabilir.':
        'Hatalı girilen IBAN veya adres bilgileri, süreçlerde gecikmelere yol açabilir.',
    'Profilime Git': 'Profilime Git',

    // --- Dues Operations ---
    'Aidat İşlemleri': 'Aidat İşlemleri',
    'Yıllık Aidat': 'Yıllık Aidat',
    '2024 yılı için belirlenen aidat tutarı ve ödeme koşulları aşağıda yer almaktadır. Katkılarınız derneğimizin gücüne güç katmaktadır.':
        '2024 yılı için belirlenen aidat tutarı ve ödeme koşulları aşağıda yer almaktadır. Katkılarınız derneğimizin gücüne güç katmaktadır.',
    'Ödeme Takvimi': 'Ödeme Takvimi',
    'Yıllık aidat ödemelerinizi her yılın ':
        'Yıllık aidat ödemelerinizi her yılın ',
    'Mart': 'Mart',
    ' ayı sonuna kadar tamamlamanız rica olunur.':
        ' ayı sonuna kadar tamamlamanız rica olunur.',
    'Makbuz Talebi': 'Makbuz Talebi',
    'Havale/EFT ile yapılan ödemelerde açıklama kısmına ':
        'Havale/EFT ile yapılan ödemelerde açıklama kısmına ',
    'TC Kimlik Numaranızı': 'TC Kimlik Numaranızı',
    ' ve ': ' ve ',
    'Ad Soyad': 'Ad Soyad',
    ' yazmayı unutmayınız. Makbuzunuz e-posta adresinize gönderilecektir.':
        ' yazmayı unutmayınız. Makbuzunuz e-posta adresinize gönderilecektir.',
    'Ödeme Yöntemleri': 'Ödeme Yöntemleri',
    'Kredi Kartı': 'Kredi Kartı',
    'Uygulama üzerinden güvenle ödeyebilirsiniz.':
        'Uygulama üzerinden güvenle ödeyebilirsiniz.',
    'Banka Havalesi': 'Banka Havalesi',
    'Dernek hesaplarına doğrudan transfer.':
        'Dernek hesaplarına doğrudan transfer.',
    'Ödeme Bilgileri': 'Ödeme Bilgileri',
    'SSL Güvenli': 'SSL Güvenli',
    'Kart Üzerindeki İsim': 'Kart Üzerindeki İsim',
    'Kart Numarası': 'Kart Numarası',
    'Son Kullanma': 'Son Kullanma',
    'CVV': 'CVV',
    'İşleniyor...': 'İşleniyor...',
    'Aidat Öde': 'Aidat Öde',
    'Aidat ödemesi başarıyla tamamlandı!':
        'Aidat ödemesi başarıyla tamamlandı!',

    // --- Membership Cancellation ---
    'Üyelik İptali': 'Üyelik İptali',
    'Ayrılmak istediğinize emin misiniz?':
        'Ayrılmak istediğinize emin misiniz?',
    'Üyeliğinizi iptal etmek yerine dondurmayı tercih edebilirsiniz. İptal işlemi kalıcıdır ve önceki bağış geçmişinize veya etkinlik katılımlarınıza erişimi sonlandırır.':
        'Üyeliğinizi iptal etmek yerine dondurmayı tercih edebilirsiniz. İptal işlemi kalıcıdır ve önceki bağış geçmişinize veya etkinlik katılımlarınıza erişimi sonlandırır.',
    'Üyeliği Dondur': 'Üyeliği Dondur',
    'Hesabınızı geçici olarak askıya alın. İstediğiniz zaman tekrar aktif edebilirsiniz. Verileriniz güvende kalır.':
        'Hesabınızı geçici olarak askıya alın. İstediğiniz zaman tekrar aktif edebilirsiniz. Verileriniz güvende kalır.',
    'Kalıcı İptal': 'Kalıcı İptal',
    'Hesabınızı ve tüm verilerinizi kalıcı olarak silin. Bekleyen ödemeleriniz varsa iptal öncesi tamamlanmalıdır.':
        'Hesabınızı ve tüm verilerinizi kalıcı olarak silin. Bekleyen ödemeleriniz varsa iptal öncesi tamamlanmalıdır.',
    'Önemli Bilgilendirme': 'Önemli Bilgilendirme',
    'İptal talebiniz 3 iş günü içerisinde işleme alınacaktır.':
        'İptal talebiniz 3 iş günü içerisinde işleme alınacaktır.',
    'Varsa bekleyen son aidat borcunuz tahsil edildikten sonra iptal gerçekleşir.':
        'Varsa bekleyen son aidat borcunuz tahsil edildikten sonra iptal gerçekleşir.',
    'Detaylı bilgi ve haklarınız için gizlilik sözleşmemizi inceleyebilirsiniz.':
        'Detaylı bilgi ve haklarınız için gizlilik sözleşmemizi inceleyebilirsiniz.',
    'Bize Ulaşın': 'Bize Ulaşın',
    'İptal İşlemini Başlat': 'İptal İşlemini Başlat',
    'Bu işlem geri alınamaz. Üyeliğinizi kalıcı olarak iptal etmek istediğinize emin misiniz?':
        'Bu işlem geri alınamaz. Üyeliğinizi kalıcı olarak iptal etmek istediğinize emin misiniz?',
    'Vazgeç': 'Vazgeç',
    'Üyeliğiniz donduruldu. İstediğiniz zaman tekrar aktif edebilirsiniz.':
        'Üyeliğiniz donduruldu. İstediğiniz zaman tekrar aktif edebilirsiniz.',
    'İptal talebiniz alınmıştır. 3 iş günü içerisinde işleme alınacaktır.':
        'İptal talebiniz alınmıştır. 3 iş günü içerisinde işleme alınacaktır.',

    // --- Live Support ---
    'Canlı Destek': 'Canlı Destek',
    'Çevrimiçi': 'Çevrimiçi',
    'Merhaba! İzge Uygulaması Destek Hattına hoş geldiniz. Size nasıl yardımcı olabilirim?':
        'Merhaba! İzge Uygulaması Destek Hattına hoş geldiniz. Size nasıl yardımcı olabilirim?',
    'Talebiniz alınmıştır. Destek ekibimiz şu an yoğun olduğu için size birazdan dönüş yapacaktır. Anlayışınız için teşekkür ederiz.':
        'Talebiniz alınmıştır. Destek ekibimiz şu an yoğun olduğu için size birazdan dönüş yapacaktır. Anlayışınız için teşekkür ederiz.',
    'Mesajınızı yazın...': 'Mesajınızı yazın...',

    // --- Donation Transparency ---
    'Bağışlar Nereye Gidiyor?': 'Bağışlar Nereye Gidiyor?',
    'Şeffaflık ilkemiz gereği, desteklerinizin her bir kuruşunun nasıl değere dönüştüğünü sizlerle paylaşıyoruz.':
        'Şeffaflık ilkemiz gereği, desteklerinizin her bir kuruşunun nasıl değere dönüştüğünü sizlerle paylaşıyoruz.',
    'Tıbbi Cihazlar': 'Tıbbi Cihazlar',
    'Hayati ekipman alımları': 'Hayati ekipman alımları',
    'Eğitim': 'Eğitim',
    'Burslar ve eğitim materyalleri': 'Burslar ve eğitim materyalleri',
    'Danışmanlık': 'Danışmanlık',
    'Psikolojik ve hukuki destek': 'Psikolojik ve hukuki destek',
    'Yönetim & Operasyon': 'Yönetim & Operasyon',
    'Kurumsal sürdürülebilirlik için minimum seviyede tutulmaktadır.':
        'Kurumsal sürdürülebilirlik için minimum seviyede tutulmaktadır.',
    'Detaylı Şeffaflık Raporu': 'Detaylı Şeffaflık Raporu',
    'Bağımsız denetim kuruluşları tarafından hazırlanan yıllık faaliyet raporlarımızı inceleyebilirsiniz.':
        'Bağımsız denetim kuruluşları tarafından hazırlanan yıllık faaliyet raporlarımızı inceleyebilirsiniz.',
    'Raporu İndir': 'Raporu İndir',

    // --- Request Status ---
    'Talep Durumu Sorgulama': 'Talep Durumu Sorgulama',
    'Daha önce oluşturduğunuz bir talebin güncel durumunu öğrenmek için talep numaranızı aşağıya giriniz.':
        'Daha önce oluşturduğunuz bir talebin güncel durumunu öğrenmek için talep numaranızı aşağıya giriniz.',
    'Talep Numarası (Örn: TLP-12345)': 'Talep Numarası (Örn: TLP-12345)',
    'Sorgulanıyor...': 'Sorgulanıyor...',
    'Sorgula': 'Sorgula',
    'Talep Numaramı Nereden Bulabilirim?':
        'Talep Numaramı Nereden Bulabilirim?',
    "Talebinizi oluşturduğunuzda size gönderilen onay e-postasında veya SMS mesajında 'TLP-' ile başlayan numaranızı bulabilirsiniz.":
        "Talebinizi oluşturduğunuzda size gönderilen onay e-postasında veya SMS mesajında 'TLP-' ile başlayan numaranızı bulabilirsiniz.",
    'ÖRNEK SONUÇ': 'ÖRNEK SONUÇ',
    'Tekerlekli Sandalye Bakımı': 'Tekerlekli Sandalye Bakımı',
    'Oluşturulma: 12 Ekim 2023': 'Oluşturulma: 12 Ekim 2023',
    'İşlemde': 'İşlemde',
    'Alındı': 'Alındı',
    'Değerlendirmede': 'Değerlendirmede',
    'Onay': 'Onay',
    'Tamamlandı': 'Tamamlandı',
    'Güncelleme: ': 'Güncelleme: ',
    'Talebiniz ilgili uzman ekibimize iletilmiştir. İnceleme süreci devam etmektedir.':
        'Talebiniz ilgili uzman ekibimize iletilmiştir. İnceleme süreci devam etmektedir.',

    // --- New Request Types ---
    'Yeni Talep Türleri': 'Yeni Talep Türleri',
    'Tıbbi Cihaz Desteği': 'Tıbbi Cihaz Desteği',
    'Tekerlekli sandalye, işitme cihazı ve diğer medikal ihtiyaçlar.':
        'Tekerlekli sandalye, işitme cihazı ve diğer medikal ihtiyaçlar.',
    'Psikolojik Danışmanlık': 'Psikolojik Danışmanlık',
    'Uzman psikologlardan ücretsiz terapi ve destek seansları.':
        'Uzman psikologlardan ücretsiz terapi ve destek seansları.',
    'Eğitim Bursu': 'Eğitim Bursu',
    'Öğrenciler için aylık burs veya kırtasiye/materyal yardımı.':
        'Öğrenciler için aylık burs veya kırtasiye/materyal yardımı.',
    'Hukuki Yardım': 'Hukuki Yardım',
    'Pro bono avukatlarımızdan hukuki danışmanlık hizmeti.':
        'Pro bono avukatlarımızdan hukuki danışmanlık hizmeti.',
    'Gerekli Belgeler Rehberi': 'Gerekli Belgeler Rehberi',
    'Tıbbi Cihaz başvuruları için doktor raporu zorunludur.':
        'Tıbbi Cihaz başvuruları için doktor raporu zorunludur.',
    'Eğitim bursu için güncel öğrenci belgesi ve gelir beyanı eklenmelidir.':
        'Eğitim bursu için güncel öğrenci belgesi ve gelir beyanı eklenmelidir.',
    'Hukuki yardım taleplerinde vaka özeti PDF veya JPEG formatında yüklenebilir.':
        'Hukuki yardım taleplerinde vaka özeti PDF veya JPEG formatında yüklenebilir.',
    'Yeni Talep Oluştur': 'Yeni Talep Oluştur',

    // --- Connection Issues ---
    'Uygulama ile ilgili bağlantı problemlerini çözmek için aşağıdaki adımları kontrol edebilirsiniz.':
        'Uygulama ile ilgili bağlantı problemlerini çözmek için aşağıdaki adımları kontrol edebilirsiniz.',
    'İnternet Bağlantısı Kontrolü': 'İnternet Bağlantısı Kontrolü',
    'Cihazınızın aktif bir Wi-Fi veya hücresel veri ağına bağlı olduğundan emin olun. Tarayıcınız üzerinden bir web sitesi açarak bağlantınızı test edebilirsiniz.':
        'Cihazınızın aktif bir Wi-Fi veya hücresel veri ağına bağlı olduğundan emin olun. Tarayıcınız üzerinden bir web sitesi açarak bağlantınızı test edebilirsiniz.',
    'Modeminizi yeniden başlatın.': 'Modeminizi yeniden başlatın.',
    'Hücresel veriyi kapatıp açın.': 'Hücresel veriyi kapatıp açın.',
    'Uçak modunun kapalı olduğunu doğrulayın.':
        'Uçak modunun kapalı olduğunu doğrulayın.',
    'Veri Senkronizasyonu': 'Veri Senkronizasyonu',
    'Bilgileriniz güncellenmiyorsa, manuel senkronizasyon yapmayı deneyin. Ayarlar menüsünden \'Şimdi Senkronize Et\' seçeneğini kullanabilirsiniz.':
        'Bilgileriniz güncellenmiyorsa, manuel senkronizasyon yapmayı deneyin. Ayarlar menüsünden \'Şimdi Senkronize Et\' seçeneğini kullanabilirsiniz.',
    'Sunucu Durumu': 'Sunucu Durumu',
    'Bazen sorun bizim tarafımızda olabilir. Planlı bakım veya sunucu kesintileri durumunda sosyal medya hesaplarımızdan duyuru yapmaktayız.':
        'Bazen sorun bizim tarafımızda olabilir. Planlı bakım veya sunucu kesintileri durumunda sosyal medya hesaplarımızdan duyuru yapmaktayız.',
    'Sorun devam ediyor mu?': 'Sorun devam ediyor mu?',

    // --- Device Compatibility ---
    'Cihaz Uyumluluğu': 'Cihaz Uyumluluğu',
    'Mevcut Versiyon': 'Mevcut Versiyon',
    'İzge App v1.0.4 (Güncel)': 'İzge App v1.0.4 (Güncel)',
    'Sistem Gereksinimleri': 'Sistem Gereksinimleri',
    'En iyi deneyim için cihazınızın aşağıdaki işletim sistemlerinden birini desteklediğinden emin olun.':
        'En iyi deneyim için cihazınızın aşağıdaki işletim sistemlerinden birini desteklediğinden emin olun.',
    'Android 8.0 (Oreo) ve üzeri sürümler önerilir.':
        'Android 8.0 (Oreo) ve üzeri sürümler önerilir.',
    'iOS 13 ve üzeri sürümler önerilir.': 'iOS 13 ve üzeri sürümler önerilir.',
    'Performans Bildirimi': 'Performans Bildirimi',
    'Uygulamamız, düşük donanımlı cihazlarda dahi akıcı çalışacak şekilde optimize edilmiştir. Ancak eski işletim sistemlerinde bazı modern grafiksel geçişler otomatik olarak devre dışı bırakılabilir.\n\nEğer cihazınızda donma veya yavaşlama hissediyorsanız, arka planda çalışan diğer uygulamaları kapatmayı deneyebilirsiniz.':
        'Uygulamamız, düşük donanımlı cihazlarda dahi akıcı çalışacak şekilde optimize edilmiştir. Ancak eski işletim sistemlerinde bazı modern grafiksel geçişler otomatik olarak devre dışı bırakılabilir.\n\nEğer cihazınızda donma veya yavaşlama hissediyorsanız, arka planda çalışan diğer uygulamaları kapatmayı deneyebilirsiniz.',

    // --- Other Issues ---
    'Diğer Sorunlar': 'Diğer Sorunlar',
    'Aradığınız sorunu bulamadıysanız aşağıdaki form ile bize ulaşabilirsiniz. Ekibimiz en kısa sürede size dönüş yapacaktır.':
        'Aradığınız sorunu bulamadıysanız aşağıdaki form ile bize ulaşabilirsiniz. Ekibimiz en kısa sürede size dönüş yapacaktır.',
    'Konu Başlığı': 'Konu Başlığı',
    'Lütfen bir konu seçin...': 'Lütfen bir konu seçin...',
    'Hesap İşlemleri ve Profil': 'Hesap İşlemleri ve Profil',
    'Etkinlik Katılımı / İptali': 'Etkinlik Katılımı / İptali',
    'Bağış ve Ödeme Sorunları': 'Bağış ve Ödeme Sorunları',
    'Uygulama İçi Hata (Bug)': 'Uygulama İçi Hata (Bug)',
    'Farklı Bir Konu': 'Farklı Bir Konu',
    'Detaylı Açıklama': 'Detaylı Açıklama',
    'Yaşadığınız sorunu, ne yaparken karşılaştığınızı ve ek detayları buraya yazabilirsiniz...':
        'Yaşadığınız sorunu, ne yaparken karşılaştığınızı ve ek detayları buraya yazabilirsiniz...',
    'Ekran Görüntüsü Ekle': 'Ekran Görüntüsü Ekle',
    'İsteğe bağlı, max 5MB': 'İsteğe bağlı, max 5MB',

    // --- Forgot Password Support ---
    'Şifre Sıfırlama': 'Şifre Sıfırlama',
    'Lütfen hesabınıza kayıtlı e-posta adresinizi girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.':
        'Lütfen hesabınıza kayıtlı e-posta adresinizi girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.',
    'Bağlantı Gönder': 'Bağlantı Gönder',
    'Giriş Ekranına Dön': 'Giriş Ekranına Dön',

    // --- Forgot Password Failed ---
    'Bağlantı Gönderilemedi': 'Bağlantı Gönderilemedi',
    'Bir hata oluştuğu için şifre sıfırlama bağlantısı e-posta adresinize gönderilemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.':
        'Bir hata oluştuğu için şifre sıfırlama bağlantısı e-posta adresinize gönderilemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.',
    'Deneniyor...': 'Deneniyor...',
    'Tekrar Dene': 'Tekrar Dene',

    // --- Email Verification Support & Failed ---
    'E-posta Doğrulama': 'E-posta Doğrulama',
    'E-posta adresinize gönderilen 6 haneli doğrulama kodunu giriniz.':
        'E-posta adresinize gönderilen 6 haneli doğrulama kodunu giriniz.',
    'Doğrula': 'Doğrula',
    'Doğrulama Başarısız': 'Doğrulama Başarısız',
    'Doğrulama kodu geçersiz veya süresi dolmuş olabilir. Lütfen kodunuzu kontrol edin veya yeni bir kod talep edin.':
        'Doğrulama kodu geçersiz veya süresi dolmuş olabilir. Lütfen kodunuzu kontrol edin veya yeni bir kod talep edin.',
    'Kodun Süresi Doldu': 'Kodun Süresi Doldu',
    'Güvenliğiniz için kodlar 5 dakika geçerlidir.':
        'Güvenliğiniz için kodlar 5 dakika geçerlidir.',
    'Yeni Kod Gönder': 'Yeni Kod Gönder',
    'Geri Dön': 'Geri Dön',

    // --- Account Recovery ---
    'Hesap Kurtarma': 'Hesap Kurtarma',
    'Güvenliğiniz için kimliğinizi doğrulamamız gerekiyor. Lütfen aşağıdaki yöntemlerden birini seçin.':
        'Güvenliğiniz için kimliğinizi doğrulamamız gerekiyor. Lütfen aşağıdaki yöntemlerden birini seçin.',
    'E-posta ile Doğrulama': 'E-posta ile Doğrulama',
    'Sistemde kayıtlı e-posta adresinizle':
        'Sistemde kayıtlı e-posta adresinizle',
    'Kayıtlı Telefon Numarası ile SMS': 'Kayıtlı Telefon Numarası ile SMS',
    'Kayıtlı numaranıza kod gönderilir': 'Kayıtlı numaranıza kod gönderilir',
    'Devam Et': 'Devam Et',
    'Destek Merkezi ile İletişime Geç': 'Destek Merkezi ile İletişime Geç',

    // --- Additional Support & Question Details ---
    'Destek Merkezi': 'Destek Merkezi',
    'Soru Detayı': 'Soru Detayı',
    'Son Güncelleme': 'Son Güncelleme',
    '2 gün önce': '2 gün önce',
    'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz. İşlemi tamamlamak için aşağıdaki adımları sırasıyla takip ediniz:':
        'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz. İşlemi tamamlamak için aşağıdaki adımları sırasıyla takip ediniz:',
    'Adım Adım Talep Oluşturma': 'Adım Adım Talep Oluşturma',
    'Talep Durumunu Takip Etme': 'Talep Durumunu Takip Etme',
    'Talebinizi oluşturduktan sonra, "Talepler" sekmesi altındaki "Geçmiş Taleplerim" listesinden sürecin hangi aşamada olduğunu takip edebilirsiniz. Talebiniz onaylandığında, işleme alındığında ve çözümlendiğinde size anlık bildirim (push notification) olarak bilgi verilecektir.\n\nEğer oluşturduğunuz bir talebi iptal etmek isterseniz, talep detay sayfasına girerek "Talebi İptal Et" seçeneğini kullanabilirsiniz. Ancak işleme alınmış talepler iptal edilememektedir.':
        'Talebinizi oluşturduktan sonra, "Talepler" sekmesi altındaki "Geçmiş Taleplerim" listesinden sürecin hangi aşamada olduğunu takip edebilirsiniz. Talebiniz onaylandığında, işleme alındığında ve çözümlendiğinde size anlık bildirim (push notification) olarak bilgi verilecektir.\n\nEğer oluşturduğunuz bir talebi iptal etmek isterseniz, talep detay sayfasına girerek "Talebi İptal Et" seçeneğini kullanabilirsiniz. Ancak işleme alınmış talepler iptal edilememektedir.',
    'Bu makale yardımcı oldu mu?': 'Bu makale yardımcı oldu mu?',
    'Evet': 'Evet',
    'Hayır': 'Hayır',
    'Talep Detayları': 'Talep Detayları',
    'Lütfen ihtiyacınız olan destek türünü ve detaylarını eksiksiz doldurunuz.':
        'Lütfen ihtiyacınız olan destek türünü ve detaylarını eksiksiz doldurunuz.',
    'Kategori Seçimi': 'Kategori Seçimi',
    'Kategori seçiniz': 'Kategori seçiniz',
    'Talep Başlığı': 'Talep Başlığı',
    'Örn: Tekerlekli Sandalye İhtiyacı': 'Örn: Tekerlekli Sandalye İhtiyacı',
    'Durumunuzu ve ihtiyacınızı detaylı bir şekilde açıklayınız...':
        'Durumunuzu ve ihtiyacınızı detaylı bir şekilde açıklayınız...',
    'Gerekli Belgeler (İsteğe Bağlı)': 'Gerekli Belgeler (İsteğe Bağlı)',
    'Belge Yüklemek İçin Tıklayın': 'Belge Yüklemek İçin Tıklayın',
    'Öğrenci belgesi, doktor raporu vb. (Max 5MB)':
        'Öğrenci belgesi, doktor raporu vb. (Max 5MB)',
    'Talebi Gönder': 'Talebi Gönder',
    'Talebiniz başarıyla oluşturuldu! (TLP-10492)':
        'Talebiniz başarıyla oluşturuldu! (TLP-10492)',
    'Lütfen bir talep kategorisi seçiniz.':
        'Lütfen bir talep kategorisi seçiniz.',
    'Başlık zorunludur': 'Başlık zorunludur',
    'Açıklama zorunludur': 'Açıklama zorunludur',
    'Sık karşılaşılan sorunlar için aşağıdaki çözüm adımlarını inceleyin.':
        'Sık karşılaşılan sorunlar için aşağıdaki çözüm adımlarını inceleyin.',
    'Sorununuzu arayın...': 'Sorununuzu arayın...',
    'Belge yükleme hatası alıyorum': 'Belge yükleme hatası alıyorum',
    'İnternet bağlantınızı kontrol edin.':
        'İnternet bağlantınızı kontrol edin.',
    'Belge boyutunun 5MB\'ı aşmadığından emin olun.':
        'Belge boyutunun 5MB\'ı aşmadığından emin olun.',
    'Desteklenen formatlarda (PDF, JPG, PNG) yükleme yaptığınızı doğrulayın.':
        'Desteklenen formatlarda (PDF, JPG, PNG) yükleme yaptığınızı doğrulayın.',
    'Uygulamayı kapatıp tekrar açmayı deneyin.':
        'Uygulamayı kapatıp tekrar açmayı deneyin.',
    'Uygulama donma veya çökme sorunu': 'Uygulama donma veya çökme sorunu',
    'Uygulamanın güncel sürümünü kullandığınızdan emin olun (App Store veya Google Play\'i kontrol edin).':
        'Uygulamanın güncel sürümünü kullandığınızdan emin olun (App Store veya Google Play\'i kontrol edin).',
    'Cihazınızda yeterli depolama alanı olduğundan emin olun.':
        'Cihazınızda yeterli depolama alanı olduğundan emin olun.',
    'Cihazınızın ayarlarından uygulama önbelleğini temizleyin.':
        'Cihazınızın ayarlarından uygulama önbelleğini temizleyin.',
    'Sorun devam ederse uygulamayı silip yeniden yükleyin.':
        'Sorun devam ederse uygulamayı silip yeniden yükleyin.',
    'Adres doğrulama problemi': 'Adres doğrulama problemi',
    'Cihazınızın konum servislerinin açık olduğundan emin olun.':
        'Cihazınızın konum servislerinin açık olduğundan emin olun.',
    'Uygulamaya konum erişim izni verdiğinizi kontrol edin (Ayarlar > İzge App > Konum).':
        'Uygulamaya konum erişim izni verdiğinizi kontrol edin (Ayarlar > İzge App > Konum).',
    'Manuel adres girerken posta kodunuzu doğru yazdığınızdan emin olun.':
        'Manuel adres girerken posta kodunuzu doğru yazdığınızdan emin olun.',
    'Hala sorun mu yaşıyorsunuz?': 'Hala sorun mu yaşıyorsunuz?',
    'Destek ekibimiz size yardımcı olmak için burada.':
        'Destek ekibimiz size yardımcı olmak için burada.',

    // --- Donate Screen ---
    'Tek Seferlik': 'Tek Seferlik',
    'Aylık Düzenli': 'Aylık Düzenli',
    'Nereye Destek Olmak İstersiniz?': 'Nereye Destek Olmak İstersiniz?',
    'Genel Bağış': 'Genel Bağış',
    'Tekerlekli Sandalye': 'Tekerlekli Sandalye',
    'Gıda Paketi': 'Gıda Paketi',
    'Bağış Miktarı': 'Bağış Miktarı',
    'Diğer Miktar': 'Diğer Miktar',
    'Aylık Bağışı Başlat': 'Aylık Bağışı Başlat',
    'Bağışı Tamamla': 'Bağışı Tamamla',
    'Aylık düzenli bağışlarınız, her ayın aynı gününde kartınızdan otomatik olarak çekilecektir. İstediğiniz zaman iptal edebilirsiniz.':
        'Aylık düzenli bağışlarınız, her ayın aynı gününde kartınızdan otomatik olarak çekilecektir. İstediğiniz zaman iptal edebilirsiniz.',
    'Yukarıdaki butona tıklayarak Aydınlatma Metni\'ni okuduğunuzu ve kabul ettiğinizi onaylamış olursunuz.':
        'Yukarıdaki butona tıklayarak Aydınlatma Metni\'ni okuduğunuzu ve kabul ettiğinizi onaylamış olursunuz.',

    // --- Events Screen ---
    'Ekim 2023': 'Ekim 2023',
    'Günün Etkinlikleri': 'Günün Etkinlikleri',
    'Bugün, 12 Ekim': 'Bugün, 12 Ekim',
    'Etkinlikler yüklenirken hata oluştu: ':
        'Etkinlikler yüklenirken hata oluştu: ',
    'Henüz planlanmış bir etkinlik yok': 'Henüz planlanmış bir etkinlik yok',

    'Bağla': 'Bağla',
  };

  static final Map<String, String> _enTranslations = {
    // Tab & Drawer & Navigation
    'Anasayfa': 'Home',
    'Haberler': 'News',
    'Talepler': 'Requests',
    'Anketler': 'Surveys',
    'Profil': 'Profile',
    'Profilim': 'My Profile',
    'Bağış Yap': 'Donate',
    'Bağış Geçmişi': 'Donation History',
    'Ayarlar': 'Settings',
    'Dernek Hakkında': 'About Us',
    'Yardım Merkezi': 'Help Center',
    'Çıkış Yap': 'Log Out',
    'DİL': 'LANGUAGE',
    'TEMA': 'THEME',
    'AKTİVİTEM': 'MY ACTIVITY',
    'Beğenilenler': 'Liked',
    'Kaydedilenler': 'Saved',
    'Etkinlikler': 'Events',
    'KAYDEDİLENLER': 'SAVED ITEMS',
    'Kaydedilen Haberler': 'Saved News',
    'Favori Etkinlikler': 'Favorite Events',
    'DESTEK ÖZETİ': 'SUPPORT SUMMARY',
    'Bağış Geçmişim': 'My Donations',

    // Home
    'Merhaba': 'Hello',
    'Bekleyen 1 talebiniz var.': 'You have 1 pending request.',
    'Talep Aç': 'Open Request',
    'Destek': 'Support',
    'Öne Çıkanlar': 'Featured',
    'Hepsini Gör': 'See All',
    'Tümünü Gör': 'View All',
    'Yaklaşan Etkinlikler': 'Upcoming Events',
    'Aktif anket bulunmuyor': 'No active surveys found',
    'Bizi Takip Edin': 'Follow Us',
    'Size yardımcı olmak için buradayız. Hemen sohbete başlayın.':
        'We are here to help you. Start chatting now.',
    'Bize Yazın': 'Contact Us',
    'Henüz talep bulunmuyor': 'No requests yet',
    'Yaklaşan etkinlik bulunmuyor': 'No upcoming events',
    'ETKİNLİK': 'EVENT',
    'DUYURU': 'ANNOUNCEMENT',
    'Engelsiz Yaşam Buluşması': 'Accessible Life Meeting',
    'Yeni Rehabilitasyon Merkezi': 'New Rehabilitation Center',

    // Event Detail Screen
    'Etkinlik Detayı': 'Event Details',
    'Seminer': 'Seminar',
    '12 Haziran 2024': 'June 12, 2024',
    'Çarşamba': 'Wednesday',
    'Başlangıç': 'Start',
    'Kültür Merkezi': 'Cultural Center',
    'Ankara': 'Ankara',
    'ORGANİZATÖR': 'ORGANIZER',
    'Etkinlik Hakkında': 'About the Event',
    'Etkinliğe Katıl': 'Join Event',
    'Etkinlik Kaydı': 'Event Registration',
    'Tekerlekli Sandalye Erişimi': 'Wheelchair Access',
    'Rampa veya asansör ihtiyacım var': 'I need a ramp or elevator',
    'İşaret Dili Çevirmeni': 'Sign Language Interpreter',
    'Refakatçi İle Katılacağım': 'I Will Attend with a Companion',
    'Kaydı Tamamla': 'Complete Registration',

    // Notifications Screen
    'Bildirimler': 'Notifications',
    'Yeni Bildiriminiz Yok': 'No New Notifications',
    'Dernekten veya katıldığınız etkinliklerden gelecek güncel bildirimler burada listelenecektir.':
        'Upcoming notifications from the association or events you have joined will be listed here.',
    'Ana Sayfaya Dön': 'Return to Home',

    // Events Screen
    'Etkinlik Takvimi': 'Event Calendar',

    // Profile Linked Accounts
    'Bağla': 'Link',

    // Event Detail Screen - long description texts (EN)
    'Engelli bireylerin sosyal hayata katılımını desteklemek ve farkındalık yaratmak amacıyla düzenlediğimiz "Engelsiz Yaşam Buluşması"nda sizleri de aramızda görmekten mutluluk duyarız.':
        'We would be delighted to see you at our "Accessible Life Meeting", organized to support the participation of individuals with disabilities in social life and raise awareness.',
    'Bu özel etkinlikte, alanında uzman konuşmacılarımızın sunumları, atölye çalışmaları ve interaktif paneller yer alacaktır. Birlikte daha güçlü, erişilebilir ve kapsayıcı bir toplum inşa etmek için fikir alışverişinde bulunacağız.':
        'This special event will feature presentations by expert speakers, workshops, and interactive panels. Together, we will exchange ideas to build a stronger, more accessible and inclusive society.',
    'Lütfen varsa özel gereksinimlerinizi belirtin. Bu bilgiler, etkinliği sizin için daha erişilebilir hale getirmemize yardımcı olacaktır.':
        'Please specify your special requirements, if any. This information will help us make the event more accessible for you.',

    // Event Success Screen (EN)
    'Katılım Onayı': 'Registration Confirmed',
    'Kaydınız başarıyla oluşturulmuştur. Etkinlik detayları ve güncellemeler için takipte kalın.':
        'Your registration has been successfully created. Stay tuned for event details and updates.',
    'Etkinlik': 'Event',
    'Tarih': 'Date',
    'Konum': 'Location',
    'Etkinliklerime Git': 'Go to My Events',
    'Anasayfaya Dön': 'Return to Home',

    // Settings & Language Screen
    'Genel': 'General',
    'Bildirim Ayarları': 'Notification Settings',
    'Dil Tercihi': 'Language Preference',
    'Karanlık Mod': 'Dark Mode',
    'Güvenlik': 'Security',
    'Hesap Güvenliği': 'Account Security',
    'Gizlilik Politikası': 'Privacy Policy',
    'Hakkımızda': 'About Us',
    'Uygulamayı kullanmak istediğiniz dili seçin.':
        'Choose the language you want to use the application in.',
    'Kaydet': 'Save',

    // Roles
    'Gönüllü Üye': 'Volunteer Member',
    'Yönetici': 'Administrator',
    'Moderatör': 'Moderator',
    'Kurumsal Erişim': 'Corporate Access',

    // Profile
    'Kişisel Bilgiler': 'Personal Info',
    'Etkinlik Katılımlarım': 'My Events',
    'Taleplerim': 'My Requests',
    'BAĞLI HESAPLAR': 'LINKED ACCOUNTS',

    // New Request
    'Dosya Kaynağı Seçin': 'Choose File Source',
    'Kamera': 'Camera',
    'Galeri': 'Gallery',
    'Dosyalar': 'Files',
    'İhtiyacınızı bize bildirin, size en kısa sürede yardımcı olalım.':
        'Let us know your need, we will help you as soon as possible.',
    'Talep Türü': 'Request Type',
    'Lütfen bir tür seçin': 'Please choose a type',
    'İlaç Yardımı': 'Medication Support',
    'Eğitim Desteği': 'Education Support',
    'Psikolojik Destek': 'Psychological Support',
    'Talep Detayı': 'Request Details',
    'Talebinizi buraya detaylı bir şekilde yazınız...':
        'Write your request here in detail...',
    'Ek Dosya (İsteğe Bağlı)': 'Attachment (Optional)',
    'Dosya Ekle': 'Add File',
    'Talebiniz başarıyla gönderildi.': 'Your request was sent successfully.',
    'Talep Gönder': 'Send Request',

    // News
    'Haberler ve Duyurular': 'News & Announcements',
    'Dernekten en güncel haberler': 'Latest news from the association',
    'Haberlerde ara...': 'Search news...',
    'Tümü': 'All',
    'Duyurular': 'Announcements',
    'Projeler': 'Projects',
    'Haber Bulunamadı': 'News Not Found',
    'Aradığınız kriterlere uygun haber veya duyuru bulunmuyor. Farklı bir arama yapmayı deneyebilirsiniz.':
        'No news or announcements fit your search criteria. Try a different search.',
    'Tüm Haberleri Gör': 'See All News',
    'Devamını Oku': 'Read More',
    'Yükleniyor...': 'Loading...',
    'Daha Fazla Yükle': 'Load More',

    // Requests
    'Henüz Bir Talep Oluşturmadınız': 'You Haven\'t Created Any Requests Yet',
    'İhtiyaç duyduğunuz konularda talep oluşturarak\nbizden destek alabilirsiniz.':
        'You can get support from us by opening requests for your needs.',
    'Yeni Talep': 'New Request',

    // Surveys
    'Aktif Anketler': 'Active Surveys',
    'Henüz oluşturulmuş bir anket yok.': 'No surveys created yet.',
    'Şu anda aktif anket bulunmuyor.': 'No active surveys at the moment.',
    'Geçmiş Anketler': 'Past Surveys',
    'Geçmiş anket bulunmuyor.': 'No past surveys found.',
    'Ankete Katıl': 'Take Survey',
    'Sonuçlandı': 'Concluded',
    'Gün Kaldı': 'Days Left',
    'Devam Ediyor': 'Ongoing',

    // Dynamic/Static Survey Fields
    'Dernek Faaliyetleri Anketi': 'Association Activities Survey',
    'Dernek faaliyetleri hakkında geri bildirimleriniz.':
        'Your feedback on association activities.',
    'Yeni Logo Tasarımı': 'New Logo Design',
    'Dernek logosunun yeni tasarımı hakkında oylama.':
        'Voting on the new design of the association logo.',
    'Yeni Dönem Eğitim Atölyesi Tercihleri':
        'New Term Training Workshop Preferences',
    'Değerli üyemiz, önümüzdeki çeyrekte açılacak olan ücretsiz eğitim atölyelerimizin odak noktasını belirlemek için görüşünüze ihtiyacımız var. Lütfen size en faydalı olacak alanı seçiniz.':
        'Dear member, we need your opinion to determine the focus of our free training workshops that will open in the next quarter. Please choose the area that will be most beneficial to you.',
    'Haftalık Memnuniyet Anketi': 'Weekly Satisfaction Survey',
    'TOPLULUK GELİŞİMİ': 'COMMUNITY DEVELOPMENT',
    '1,248 Katılım': '1,248 Participations',
    'Son 2 Gün': '2 Days Left',
    'Hangi alanda atölye açılmasını istersiniz?':
        'In which field would you like a workshop to be opened?',
    'Yalnızca bir seçenek işaretleyebilirsiniz.':
        'You can only choose one option.',
    'Yazılım & Teknoloji': 'Software & Technology',
    'Kodlama, Veri Analizi, Yapay Zeka':
        'Coding, Data Analysis, Artificial Intelligence',
    'Sürdürülebilirlik & Çevre': 'Sustainability & Environment',
    'İklim Krizi, İleri Dönüşüm, Ekoloji': 'Climate Crisis, Upcycling, Ecology',
    'Sanat & Tasarım': 'Art & Design',
    'Grafik Tasarım, Seramik, Fotoğrafçılık':
        'Graphic Design, Ceramics, Photography',
    'Girişimcilik & Liderlik': 'Entrepreneurship & Leadership',
    'Proje Yönetimi, İletişim Becerileri':
        'Project Management, Communication Skills',
    'Kaydediliyor...': 'Saving...',
    'Yanıtınız Alındı': 'Response Received',
    'Yanıtı Gönder': 'Submit Response',
    'Yanıtınız başarıyla kaydedildi.':
        'Your response has been successfully recorded.',
    'Anket Sonuçları': 'Survey Results',
    'Katılım': 'Participation',
    '1,240 Kişi': '1,240 People',
    'Durum': 'Status',
    'Hizmet kalitemizden memnun musunuz?':
        'Are you satisfied with our service quality?',
    'Çok Memnunum': 'Very Satisfied',
    'Memnunum': 'Satisfied',
    'Kararsızım': 'Undecided',
    'Yeni etkinlik önerilerinizi bizimle paylaşır mısınız?':
        'Would you share your new event suggestions with us?',
    'Sosyal Etkinlik': 'Social Event',
    'Spor': 'Sports',
    'Diğer Anketlere Göz At': 'Browse Other Surveys',

    // Specific Database Active Surveys from User Screenshot
    'Uygulamanın yeni premium tasarımını nasıl buldunuz?':
        "How did you find the application's new premium design?",
    'Siz değerli kullanıcılarımızın geri bildirimleri bizim için çok önemli.':
        'The feedback from you, our valued users, is very important to us.',
    'Hangi afet eğitimlerine daha çok ağırlık verilmeli?':
        'Which disaster training should be prioritized more?',
    'Gelecek ay planlanacak yüz yüze eğitim seminerlerinin ana konusunu hep birlikte belirliyoruz.':
        'Together, we are determining the main topic of the face-to-face training seminars to be planned next month.',

    // Personal Information Screen
    'Fotoğrafı Değiştir': 'Change Photo',
    'Bilgileriniz başarıyla kaydedildi!':
        'Your information has been successfully saved!',
    'Adınız Soyadınız': 'Your full name',
    'E-posta': 'Email',
    'E-posta adresiniz': 'Your email address',
    'Telefon': 'Phone',
    'Telefon numaranız': 'Your phone number',
    'Adres': 'Address',
    'Açık adresiniz...': 'Your street address...',

    // Rights & Obligations Screen
    'Haklar ve Yükümlülükler': 'Rights and Obligations',
    'Üye Hakları ve Sorumlulukları': 'Member Rights and Responsibilities',
    'Dernek tüzüğüne göre, yönetim kurulu ve normal üyelerin temel hak ve yükümlülükleri aşağıda özetlenmiştir.':
        'According to the association charter, the basic rights and obligations of the board of directors and normal members are summarized below.',
    'Temel Haklar': 'Basic Rights',
    'Genel Kurul ve Oy Hakkı': 'General Assembly and Voting Rights',
    'Tüm asil üyeler genel kurula katılma, söz alma ve dernek organları için oy kullanma hakkına sahiptir.':
        'All active members have the right to attend the general assembly, speak, and vote for the association bodies.',
    'Bilgi Edinme': 'Right to Information',
    'Üyeler, derneğin faaliyetleri, mali durumu ve alınan kararlar hakkında düzenli olarak bilgilendirilme hakkına sahiptir.':
        'Members have the right to be regularly informed about the association\'s activities, financial status, and decisions made.',
    'Yükümlülükler': 'Obligations',
    'Tüzüğe Uygunluk': 'Compliance with Charter',
    'Her üye dernek tüzüğüne, genel kurul ve yönetim kurulu kararlarına uymakla yükümlüdür.':
        'Every member is obliged to comply with the association charter, general assembly, and board of directors decisions.',
    'Aidat Sorumluluğu': 'Membership Dues Responsibility',
    'Üyeler, genel kurul tarafından belirlenen yıllık üyelik aidatlarını zamanında ödemekle yükümlüdür. Aksi halde üyelik askıya alınabilir.':
        'Members are obliged to pay the annual membership dues determined by the general assembly on time. Otherwise, membership may be suspended.',
    'Dernek İtibarını Koruma': 'Protecting the Association\'s Reputation',
    'Üyeler, derneğin vizyon ve misyonuna aykırı davranışlardan kaçınmalı ve derneğin itibarını zedeleyici faaliyetlerde bulunmamalıdır.':
        'Members must avoid behaviors contrary to the association\'s vision and mission, and must not engage in activities that damage the reputation of the association.',
    'Detaylı Bilgi': 'Detailed Information',
    'Dernek tüzüğünün tamamına ve tüm hukuki detaylara mevzuat sayfasından ulaşabilirsiniz.':
        'You can access the full charter of the association and all legal details on the legislation page.',
    'Tüzüğü İndir': 'Download Charter',

    // About Us Screen
    'İzge Derneği': 'Izge Association',
    'Toplum İçin Birlikte Büyüyoruz.': 'We Grow Together for Society.',
    'Hikayemiz': 'Our Story',
    'İzge Derneği, toplumsal dayanışmayı güçlendirmek ve dezavantajlı gruplara sürdürülebilir destek sağlamak amacıyla kuruldu. Bir avuç gönüllünün çabasıyla başlayan bu yolculuk, bugün binlerce hayata dokunan büyük bir aileye dönüştü. Amacımız, yardımlaşmayı şeffaf ve ulaşılabilir kılarak daha adil bir yarın inşa etmektir.':
        'Izge Association was established to strengthen social solidarity and provide sustainable support to disadvantaged groups. This journey, which started with the efforts of a handful of volunteers, has turned into a big family touching thousands of lives today. Our aim is to build a fairer tomorrow by making mutual aid transparent and accessible.',
    'Vizyonumuz': 'Our Vision',
    'Her bireyin temel haklarına erişebildiği, eşitlikçi ve dayanışma odaklı bir toplum modelini hayata geçirmek.':
        'To realize an egalitarian and solidarity-oriented society model where every individual can access their basic rights.',
    'Misyonumuz': 'Our Mission',
    'İhtiyaç sahipleri ile gönüllüleri güvenli bir platformda buluşturarak, yerel ve ulusal çapta kalıcı çözümler üretmek.':
        'To produce permanent solutions locally and nationally by bringing together those in need and volunteers in a secure platform.',
    'Değerlerimiz': 'Our Values',
    'Eşitlik': 'Equality',
    'Erişilebilirlik': 'Accessibility',
    'Dayanışma': 'Solidarity',
    'Şeffaflık': 'Transparency',
    'Bizimle İletişime Geçin': 'Contact Us',
    'Merkez Mah. Güneş Sok. No:1 Ankara':
        'Merkez District, Gunes Street No:1 Ankara',

    // --- My Event Participations (Etkinlik Katılımlarım) ---
    'Yaklaşan': 'Upcoming',
    'Geçmiş': 'Past',
    'YAKLAŞAN': 'UPCOMING',
    'Engelsiz Sanat Atölyesi': 'Barrier-Free Art Workshop',
    '25 Haziran, 14:00': 'June 25, 14:00',
    'Dernek Merkezi': 'Association Headquarters',
    'Gönüllü Oryantasyonu': 'Volunteer Orientation',
    '30 Haziran, 10:00': 'June 30, 10:00',
    'Online (Zoom)': 'Online (Zoom)',
    'Katılım Onaylandı': 'Participation Confirmed',
    'Onay Bekleniyor': 'Pending Approval',
    'Erişilebilirlik Zirvesi 2023': 'Accessibility Summit 2023',
    '15 Mayıs, 10:00': 'May 15, 10:00',
    'İstanbul Kültür Merkezi': 'Istanbul Cultural Center',
    'Katıldı': 'Attended',
    'Engelsiz Basketbol Turnuvası': 'Barrier-Free Basketball Tournament',
    '2 Nisan, 14:30': 'April 2, 14:30',
    'Atatürk Spor Kompleksi': 'Ataturk Sports Complex',
    'Dijital Okuryazarlık Atölyesi': 'Digital Literacy Workshop',
    '12 Mart, 19:00': 'March 12, 19:00',

    // --- Past Requests (Geçmiş Talepler) ---
    'Geçmiş Talepler': 'Past Requests',
    'İhtiyaç duyduğunuz konularda talep oluşturarak bizden destek alabilirsiniz.':
        'You can get support from us by opening requests for your needs.',

    // --- Notification Settings (Bildirim Ayarları) ---
    'Uygulama içi ve anlık bildirim tercihlerinizi buradan yönetebilirsiniz.':
        'You can manage your in-app and push notification preferences here.',
    'Genel Bildirimler': 'General Notifications',
    'Tüm anlık bildirimleri açıp kapatın.':
        'Turn all push notifications on or off.',
    'Önemli güncellemeler ve haberler': 'Important updates and news',
    'Yeni Etkinlikler': 'New Events',
    'Yaklaşan etkinlikler ve davetler': 'Upcoming events and invitations',
    'Talep Güncellemeleri': 'Request Updates',
    'Taleplerinizin durum değişiklikleri': 'Status changes of your requests',
    'Bağış Hatırlatıcıları': 'Donation Reminders',
    'Düzenli bağış bildirimleri': 'Regular donation notifications',

    // --- Account Security (Hesap Güvenliği) ---
    'ŞİFRE İŞLEMLERİ': 'PASSWORD TRANSACTIONS',
    'GÜVENLİK KATMANLARI': 'SECURITY LAYERS',
    'İki Faktörlü Doğrulama': 'Two-Factor Authentication',
    'Ekstra güvenlik şartları': 'Extra security conditions',
    'Biyometrik Giriş\n(FaceID/Parmak İzi)':
        'Biometric Login\n(FaceID/Fingerprint)',
    'OTURUM YÖNETİMİ': 'SESSION MANAGEMENT',
    'Aktif Cihazlar': 'Active Devices',
    'Bu Cihaz: iPhone 14 Pro': 'This Device: iPhone 14 Pro',
    'HESAP İŞLEMLERİ': 'ACCOUNT ACTIONS',
    'Bu işlem kalıcıdır': 'This action is permanent',
    'Emin misiniz?': 'Are you sure?',
    'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem kalıcıdır ve geri alınamaz.':
        'Are you sure you want to delete your account? This action is permanent and cannot be undone.',
    'İptal': 'Cancel',
    'Hesap silme talebiniz alınmıştır.':
        'Your account deletion request has been received.',

    // --- Active Devices (Aktif Cihazlar) ---
    'Hesabınıza erişimi olan tüm cihazlar burada listelenir.':
        'All devices with access to your account are listed here.',
    'Oturumu Kapat': 'Log Out',
    'cihazındaki oturumu kapatmak istediğinize emin misiniz?':
        'device? Are you sure you want to log out?',
    'Oturum başarıyla kapatıldı!': 'Logged out successfully!',
    'Kapat': 'Log Out',
    'Son görülme: Dün, 14:30': 'Last seen: Yesterday, 14:30',
    'Son görülme: 3 gün önce': 'Last seen: 3 days ago',
    'İstanbul, TR': 'Istanbul, TR',
    'Ankara, TR': 'Ankara, TR',
    'İzmir, TR': 'Izmir, TR',
    'Şu an aktif': 'Active now',

    // --- Account Security Fixes ---
    'Şifre Değiştir': 'Change Password',
    'Hesabımı Sil': 'Delete My Account',

    // --- Donation History (Bağış Geçmişi) ---
    'Henüz Bağış Yapmadınız': "You Haven't Donated Yet",
    'Derneğimize yapacağınız bağışlar burada listelenecektir. Destek olmak için bağış sayfasını ziyaret edebilirsiniz.':
        'Your donations to our association will be listed here. You can visit the donation page to support us.',

    // --- Change Password (Şifre Değiştir) ---
    'Hesap güvenliğiniz için şifrenizi güncel tutun.':
        'Keep your password updated for your account security.',
    'Mevcut Şifre': 'Current Password',
    'Mevcut şifrenizi girin': 'Enter your current password',
    'Yeni Şifre': 'New Password',
    'Yeni şifrenizi belirleyin': 'Set your new password',
    'Şifre Gereksinimleri:': 'Password Requirements:',
    'En az 8 karakter': 'At least 8 characters',
    'En az 1 rakam': 'At least 1 digit',
    'En az 1 özel karakter': 'At least 1 special character',
    'Yeni Şifre (Tekrar)': 'New Password (Repeat)',
    'Yeni şifrenizi doğrulayın': 'Verify your new password',
    'Güncelleniyor...': 'Updating...',
    'Şifreyi Güncelle': 'Update Password',
    'Şifreler eşleşmiyor!': 'Passwords do not match!',
    'Şifreniz başarıyla güncellendi!':
        'Your password has been successfully updated!',

    // --- Help Center (Yardım Merkezi) ---
    'Size nasıl yardımcı\nolabiliriz?': 'How can we help\nyou?',
    'Sorunuzu arayın (örn: bağış yapmak)':
        'Search your question (e.g. make donation)',
    'Kategoriler': 'Categories',
    'Üyelik İşlemleri': 'Membership Procedures',
    'Bağışlar': 'Donations',
    'Sıkça Sorulan Sorular': 'Frequently Asked Questions',
    'Detaylı Oku': 'Read Details',
    'Aradığınızı bulamadınız mı?': 'Could not find what you were looking for?',
    'Destek ekibimiz size yardımcı olmak için hazır. Hafta içi 09:00 - 18:00 arası canlı destek alabilirsiniz.':
        'Our support team is ready to help you. You can get live support on weekdays between 09:00 - 18:00.',
    'Canlı Destek Başlat': 'Start Live Support',
    'Uygulama üzerinden nasıl talep oluşturabilirim?':
        'How can I create a request through the application?',
    'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz.':
        'Creating a new request via Izge App is very simple and fast. You can send any kind of need or suggestion regarding our community to us through this system.',
    'Derneğe nasıl üye olabilirim?':
        'How can I become a member of the association?',
    'Üyelik formunu \'Üyelik İşlemleri\' bölümünden doldurarak başvurunuzu iletebilirsiniz. Başvurunuz yönetim kurulu tarafından değerlendirilip size dönüş sağlanacaktır.':
        'You can submit your application by filling out the membership form in the \'Membership Procedures\' section. Your application will be evaluated by the board of directors and you will receive feedback.',
    'Bağış makbuzuma nasıl ulaşabilirim?':
        'How can I access my donation receipt?',
    'Yaptığınız tüm bağışların elektronik makbuzlarına \'Bağışlar\' menüsü altındaki \'Geçmiş İşlemlerim\' sekmesinden ulaşabilir ve indirebilirsiniz.':
        'You can access and download the electronic receipts of all your donations from the \'My Past Transactions\' tab under the \'Donations\' menu.',
    'Etkinliklere katılım ücretli mi?': 'Is participation in events paid?',
    'Derneğimizin düzenlediği etkinliklerin büyük çoğunluğu üyelerimize ücretsizdir. Ücretli olan özel etkinliklerde, etkinlik detay sayfasında bilet bilgisi açıkça belirtilmektedir.':
        'The vast majority of the events organized by our association are free for our members. For paid special events, ticket information is clearly specified on the event detail page.',

    // --- Privacy Policy (Gizlilik Politikası) ---
    'Son Güncelleme: 24 Ekim 2023': 'Last Update: October 24, 2023',
    'İzge App olarak gizliliğinize önem veriyoruz. Bu Gizlilik Politikası, uygulamamızı ("İzge App") kullandığınızda kişisel verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklamaktadır. Hizmetlerimizi kullanarak, bu politikada belirtilen uygulamaları kabul etmiş olursunuz.':
        'As Izge App, we value your privacy. This Privacy Policy explains how your personal data is collected, used, and protected when you use our application ("Izge App"). By using our services, you accept the practices specified in this policy.',
    '1. Veri Toplama': '1. Data Collection',
    'Size daha iyi bir deneyim sunabilmek için çeşitli bilgiler topluyoruz. Bunlar şunları içerebilir:':
        'We collect various information to provide you with a better experience. These may include:',
    'Kişisel Bilgiler: ': 'Personal Information: ',
    'Hesap oluştururken sağladığınız ad, e-posta adresi, telefon numarası gibi bilgiler.':
        'Information such as name, email address, phone number you provide when creating an account.',
    'Kullanım Verileri: ': 'Usage Data: ',
    'Uygulama içindeki etkileşimleriniz, ziyaret ettiğiniz sayfalar ve tercihlerinize dair anonim veya kişiselleştirilmiş istatistikler.':
        'Anonymous or personalized statistics about your interactions within the app, pages you visit, and your preferences.',
    'Cihaz Bilgileri: ': 'Device Information: ',
    'Kullandığınız cihazın modeli, işletim sistemi sürümü ve benzersiz cihaz tanımlayıcıları.':
        'Model, operating system version, and unique device identifiers of the device you are using.',
    '2. Veri Kullanımı': '2. Data Usage',
    'Toplanan veriler, İzge App deneyiminizi iyileştirmek temel amacıyla aşağıdaki şekillerde kullanılır:':
        'The collected data is used in the following ways for the primary purpose of improving your Izge App experience:',
    'Hizmetlerimizi sağlamak, sürdürmek ve iyileştirmek.':
        'To provide, maintain, and improve our services.',
    'Talep ve anketlerinizi işleme koymak, size özel bildirimler göndermek.':
        'To process your requests and surveys, and to send you special notifications.',
    'Kullanıcı güvenliğini sağlamak ve olası dolandırıcılık veya kötüye kullanımı önlemek.':
        'To ensure user security and prevent potential fraud or abuse.',
    'Yasal yükümlülüklerimizi yerine getirmek.':
        'To fulfill our legal obligations.',
    '3. Çerezler ve İzleme': '3. Cookies and Tracking',
    'Uygulamamız, oturum yönetimi ve performans analizi için çeşitli teknik izleme yöntemleri kullanmaktadır. Bu veriler üçüncü taraf reklam ağlarıyla doğrudan paylaşılmaz. Cihaz ayarlarınızdan veri takibini sınırlandırma hakkına sahipsiniz.':
        'Our application uses various technical tracking methods for session management and performance analysis. This data is not directly shared with third-party advertising networks. You have the right to limit data tracking from your device settings.',
    '4. İletişim': '4. Contact',
    'Bu Gizlilik Politikası veya verilerinizin işlenmesiyle ilgili sorularınız, endişeleriniz veya talepleriniz varsa, lütfen bizimle iletişime geçmekten çekinmeyin:':
        'If you have any questions, concerns, or requests regarding this Privacy Policy or the processing of your data, please do not hesitate to contact us:',

    // --- Membership Help (Üyelik İşlemleri) ---
    'Nasıl yardımcı olabiliriz?': 'How can we help you?',
    'Adım adım üyelik başvuru süreci, gerekli belgeler ve onay aşamaları hakkında detaylı bilgi edinin.':
        'Get detailed information about the step-by-step membership application process, required documents, and approval stages.',
    'İletişim bilgilerinizi, adresinizi veya mesleki detaylarınızı profiliniz üzerinden nasıl güncelleyeceğinizi öğrenin.':
        'Learn how to update your contact information, address, or professional details through your profile.',
    'Yıllık üyelik aidat ödemeleri, makbuz talepleri ve geçmiş ödeme geçmişi sorgulama adımları.':
        'Annual membership dues payments, receipt requests, and steps to query past payment history.',
    'Üyeliğinizi dondurma veya tamamen iptal etme prosedürleri, yasal süreçler ve dikkat edilmesi gereken hususlar hakkında kapsamlı rehber.':
        'Comprehensive guide on freezing or completely cancelling your membership, legal processes, and matters to consider.',

    // --- Donations Help (Bağışlar) ---
    'Bağış işlemleriniz, vergi süreçleri ve fonların kullanımı hakkında detaylı bilgilere buradan ulaşabilirsiniz.':
        'You can access detailed information about your donation transactions, tax processes, and the use of funds here.',
    'Makbuz talepleri ve vergi indirim süreçleri':
        'Receipt requests and tax deduction processes',
    'Aylık Bağışlar': 'Monthly Donations',
    'Düzenli bağış başlatma, düzenleme ve iptali':
        'Starting, editing, and cancelling regular donations',
    'Şeffaflık raporları ve güncel projelerimiz':
        'Transparency reports and our current projects',
    'Başka bir sorunuz mu var?': 'Have another question?',
    'Destek ekibimiz tüm soru ve sorunlarınız için size yardımcı olmaya hazır.':
        'Our support team is ready to help you with all your questions and issues.',

    // --- Requests Help (Talepler) ---
    'Taleplerinizle ilgili sıkça sorulan sorular ve rehberler.':
        'Frequently asked questions and guides about your requests.',
    'Mevcut taleplerinizin hangi aşamada olduğunu nasıl öğrenebilirsiniz?':
        'How can you find out what stage your current requests are at?',
    'Sisteme yeni eklenen hizmet talebi kategorileri ve başvuru süreçleri.':
        'Newly added service request categories and application processes.',
    'Sorun Giderme': 'Troubleshooting',
    'Talep oluştururken hata alıyorsanız, belgeleriniz yüklenmiyorsa veya uygulamanın çökmesi durumunda izlenecek adımlar.':
        'Steps to follow if you get an error when creating a request, your documents are not uploading, or the app crashes.',
    'Çözüm Rehberini İncele': 'View Solution Guide',
    'Tamamlanmış veya iptal edilmiş taleplerinizin arşivine erişim.':
        'Access to the archive of your completed or cancelled requests.',

    // --- Technical Support (Teknik Destek) ---
    'Uygulama ile ilgili teknik sorunlarınızı çözmek için buradayız.':
        'We are here to solve your technical problems with the application.',
    'Sorununuzu arayın (örn. giriş hatası)':
        'Search your problem (e.g. login error)',
    'Giriş Problemleri': 'Login Issues',
    'Şifremi unuttum, hesabıma erişemiyorum veya doğrulama kodu gelmiyor.':
        'I forgot my password, I cannot access my account, or the verification code is not arriving.',
    'Hata Bildirimi': 'Bug Report',
    'Uygulama çöküyor, ekran donuyor veya beklenmedik bir hata mesajı alıyorum.':
        'The app is crashing, the screen is freezing, or I am getting an unexpected error message.',
    'Cihaz ve Sistem Uyumluluğu': 'Device and System Compatibility',
    'Uygulamanın sürümü, işletim sistemi gereksinimleri ve performans ayarları hakkında destek alın.':
        'Get support about the app version, operating system requirements, and performance settings.',
    'Bağlantı Sorunları': 'Connection Issues',
    'İnternet bağlantısı hatası, veri senkronizasyonu veya yavaş yüklenme problemleri.':
        'Internet connection error, data synchronization, or slow loading problems.',
    'Yukarıdaki kategorilere uymayan diğer tüm teknik sorunlar için destek talebi oluşturun.':
        'Create a support request for all other technical issues that do not fit the above categories.',
    'Destek ekibimizle doğrudan iletişime geçerek detaylı yardım alabilirsiniz.':
        'You can get detailed help by directly contacting our support team.',

    // --- Login Issues (Giriş Problemleri) ---
    'Hesabınıza erişimde yaşadığınız sorunları hızlıca çözmek için aşağıdaki adımları takip edebilirsiniz.':
        'You can follow the steps below to quickly resolve issues you are experiencing accessing your account.',
    'Şifremi Unuttum': 'I Forgot My Password',
    'Mevcut şifrenizi hatırlamıyorsanız, sisteme kayıtlı e-posta adresinizi kullanarak yeni bir şifre oluşturabilirsiniz.':
        'If you cannot remember your current password, you can create a new password using your registered email address.',
    'Şifre Sıfırlama Bağlantısı Gönder': 'Send Password Reset Link',
    'E-posta Doğrulama Kodu Gelmiyor': 'Email Verification Code Not Arriving',
    "Eğer doğrulama kodu gelen kutunuza düşmediyse, lütfen 'Gereksiz/Spam' klasörünü kontrol edin. Kodun süresi dolmuş olabilir.":
        "If the verification code did not arrive in your inbox, please check the 'Junk/Spam' folder. The code may have expired.",
    'Kodu Tekrar Gönder': 'Resend Code',
    'Hesabım Kilitlendi': 'My Account is Locked',
    'Çok sayıda hatalı giriş denemesi nedeniyle hesabınız güvenlik amacıyla geçici olarak kilitlenmiştir. Güvenlik doğrulamasını geçerek hesabınızı açabilirsiniz.':
        'Your account has been temporarily locked for security purposes due to multiple failed login attempts. You can unlock your account by passing the security verification.',
    'Kimlik Doğrulama Adımına Git': 'Go to Identity Verification Step',
    'Hâlâ sorun mu yaşıyorsunuz?': 'Still having issues?',
    'Destek ekibimiz size yardımcı olmaktan memnuniyet duyar.':
        'Our support team will be happy to assist you.',
    'Destek Talebi Oluştur': 'Create Support Request',
    'Yeni Talep Oluştur': 'Create New Request',

    // --- Tax Receipts ---
    'Vergi Makbuzları': 'Tax Receipts',
    'Makbuz Bulunamadı': 'No Receipt Found',
    'Sistemimizde adınıza düzenlenmiş bir vergi makbuzu bulunmamaktadır. Yaptığınız bağışların makbuzlarını buradan takip edebilirsiniz.':
        'There is no tax receipt issued in your name in our system. You can track the receipts of your donations here.',
    'Şimdi Bağış Yap': 'Donate Now',

    // --- Monthly Donations ---
    'Aylık Bağışlarım': 'My Monthly Donations',
    'Aylık Bağışınız Yok': 'No Monthly Donation',
    'Henüz düzenli bir bağış talimatınız bulunmamaktadır. Düzenli bağış yaparak sürdürülebilir projelere destek olabilirsiniz.':
        'You do not have a regular donation order yet. You can support sustainable projects by making regular donations.',
    'Düzenli Bağış Başlat': 'Start Regular Donation',

    // --- Contact Support ---
    'Teknik Destek': 'Technical Support',
    'Destek Ekibine Ulaşın': 'Contact Support Team',
    'Sorununuzu daha hızlı çözebilmemiz için lütfen aşağıdaki detayları doldurun.':
        'Please fill in the details below so we can resolve your issue faster.',
    'Destek Konusu': 'Support Topic',
    'Bir konu seçin': 'Select a topic',
    'Teknik Sorun': 'Technical Issue',
    'Bağış İşlemleri': 'Donation Transactions',
    'Üyelik': 'Membership',
    'Diğer': 'Other',
    'Mesajınız': 'Your Message',
    'Sorununuzu buraya detaylıca yazabilirsiniz...':
        'You can describe your issue in detail here...',
    'Ek (İsteğe Bağlı)': 'Attachment (Optional)',
    'Ekran görüntüsü yükle': 'Upload screenshot',
    'Mesajı Gönder': 'Send Message',

    // --- How to Become Member ---
    'Nasıl Üye Olunur?': 'How to Become a Member?',
    'Aramıza katılmak için aşağıdaki adımları takip ederek üyelik sürecinizi tamamlayabilirsiniz.':
        'You can complete your membership process by following the steps below to join us.',
    'Başvuru Formu': 'Application Form',
    'Sistem üzerinden dijital üyelik başvuru formunu eksiksiz ve doğru bilgilerle doldurun.':
        'Fill in the digital membership application form through the system completely and accurately.',
    'Belge Yükleme': 'Document Upload',
    'Kimlik fotokopisi ve dernek tüzüğünce talep edilen ek belgelerinizi sisteme güvenle yükleyin.':
        'Securely upload your ID copy and additional documents required by the association statute to the system.',
    'Değerlendirme Süreci': 'Evaluation Process',
    'Yönetim kurulumuz başvurunuzu ve belgelerinizi inceler. Bu süreç uygulama üzerinden takip edilebilir.':
        'Our board of directors reviews your application and documents. This process can be tracked through the app.',
    'Üyelik Aktifleşmesi': 'Membership Activation',
    "Onay sonrası giriş aidatınızı uygulama içinden ödeyerek İzge App'in tüm özelliklerini kullanmaya başlayın.":
        "After approval, pay your entry fee through the app to start using all features of İzge App.",
    'Hemen Başvur': 'Apply Now',
    'Başvuru formuna yönlendiriliyorsunuz...':
        'You are being redirected to the application form...',

    // --- Update Info Help ---
    'Bilgilerimi Güncelleme': 'Updating My Information',
    'Hesap bilgilerinizi güncel tutmak, kurum içi iletişim ve operasyonların sağlıklı yürümesi için önemlidir.':
        'Keeping your account information up to date is important for smooth internal communication and operations.',
    'Kişisel Profil': 'Personal Profile',
    'Ad, soyad, telefon ve e-posta bilgilerinizi profil ayarları bölümünden dilediğiniz zaman değiştirebilirsiniz. Değişiklikler anında sisteme yansır.':
        'You can change your name, surname, phone and email information from the profile settings section at any time. Changes are reflected in the system immediately.',
    'Adres Bilgileri': 'Address Information',
    'Gönüllülük faaliyetleri ve olası kargo gönderimleri için ikametgah adresinizin doğruluğu elzemdir. Birden fazla adres ekleyebilir, varsayılanı seçebilirsiniz.':
        'The accuracy of your residential address is essential for volunteering activities and possible shipments. You can add multiple addresses and select the default.',
    'Evrak ve Belgeler': 'Documents and Files',
    'Bağış makbuzları, KVKK onay formları veya kurum kimlik belgelerinizi dijital formatta yükleyerek arşivleyebilirsiniz.':
        'You can archive your donation receipts, GDPR consent forms, or institutional identity documents by uploading them in digital format.',
    'Dikkat Edilmesi Gerekenler': 'Things to Consider',
    'Bilgilerinizi güncellerken resmi kimliğinizdeki formatı kullanmaya özen gösterin.':
        'When updating your information, be careful to use the format on your official ID.',
    'E-posta ve telefon numarası değişikliklerinde doğrulama kodu gönderilecektir.':
        'A verification code will be sent for email and phone number changes.',
    'Hatalı girilen IBAN veya adres bilgileri, süreçlerde gecikmelere yol açabilir.':
        'Incorrectly entered IBAN or address information may cause delays in processes.',
    'Profilime Git': 'Go to My Profile',

    // --- Dues Operations ---
    'Aidat İşlemleri': 'Dues Operations',
    'Yıllık Aidat': 'Annual Dues',
    '2024 yılı için belirlenen aidat tutarı ve ödeme koşulları aşağıda yer almaktadır. Katkılarınız derneğimizin gücüne güç katmaktadır.':
        'The dues amount and payment conditions determined for 2024 are below. Your contributions strengthen our association.',
    'Ödeme Takvimi': 'Payment Schedule',
    'Yıllık aidat ödemelerinizi her yılın ':
        'Please complete your annual dues payments by the end of ',
    'Mart': 'March',
    ' ayı sonuna kadar tamamlamanız rica olunur.': ' each year.',
    'Makbuz Talebi': 'Receipt Request',
    'Havale/EFT ile yapılan ödemelerde açıklama kısmına ':
        'For payments made by wire transfer/EFT, please remember to write your ',
    'TC Kimlik Numaranızı': 'National ID Number',
    ' ve ': ' and ',
    'Ad Soyad': 'Full Name',
    ' yazmayı unutmayınız. Makbuzunuz e-posta adresinize gönderilecektir.':
        ' in the description field. Your receipt will be sent to your email address.',
    'Ödeme Yöntemleri': 'Payment Methods',
    'Kredi Kartı': 'Credit Card',
    'Uygulama üzerinden güvenle ödeyebilirsiniz.':
        'You can pay securely through the app.',
    'Banka Havalesi': 'Bank Transfer',
    'Dernek hesaplarına doğrudan transfer.':
        'Direct transfer to association accounts.',
    'Ödeme Bilgileri': 'Payment Details',
    'SSL Güvenli': 'SSL Secure',
    'Kart Üzerindeki İsim': 'Name on Card',
    'Kart Numarası': 'Card Number',
    'Son Kullanma': 'Expiry',
    'CVV': 'CVV',
    'İşleniyor...': 'Processing...',
    'Aidat Öde': 'Pay Dues',
    'Aidat ödemesi başarıyla tamamlandı!':
        'Dues payment completed successfully!',

    // --- Membership Cancellation ---
    'Üyelik İptali': 'Membership Cancellation',
    'Ayrılmak istediğinize emin misiniz?': 'Are you sure you want to leave?',
    'Üyeliğinizi iptal etmek yerine dondurmayı tercih edebilirsiniz. İptal işlemi kalıcıdır ve önceki bağış geçmişinize veya etkinlik katılımlarınıza erişimi sonlandırır.':
        'You may prefer to freeze your membership instead of cancelling it. Cancellation is permanent and terminates access to your previous donation history or event participations.',
    'Üyeliği Dondur': 'Freeze Membership',
    'Hesabınızı geçici olarak askıya alın. İstediğiniz zaman tekrar aktif edebilirsiniz. Verileriniz güvende kalır.':
        'Temporarily suspend your account. You can reactivate it at any time. Your data remains safe.',
    'Kalıcı İptal': 'Permanent Cancellation',
    'Hesabınızı ve tüm verilerinizi kalıcı olarak silin. Bekleyen ödemeleriniz varsa iptal öncesi tamamlanmalıdır.':
        'Permanently delete your account and all your data. If you have pending payments, they must be completed before cancellation.',
    'Önemli Bilgilendirme': 'Important Information',
    'İptal talebiniz 3 iş günü içerisinde işleme alınacaktır.':
        'Your cancellation request will be processed within 3 business days.',
    'Varsa bekleyen son aidat borcunuz tahsil edildikten sonra iptal gerçekleşir.':
        'Cancellation occurs after any pending dues balance is collected.',
    'Detaylı bilgi ve haklarınız için gizlilik sözleşmemizi inceleyebilirsiniz.':
        'You can review our privacy agreement for detailed information and your rights.',
    'Bize Ulaşın': 'Contact Us',
    'İptal İşlemini Başlat': 'Start Cancellation Process',
    'Bu işlem geri alınamaz. Üyeliğinizi kalıcı olarak iptal etmek istediğinize emin misiniz?':
        'This action cannot be undone. Are you sure you want to permanently cancel your membership?',
    'Vazgeç': 'Cancel',
    'Üyeliğiniz donduruldu. İstediğiniz zaman tekrar aktif edebilirsiniz.':
        'Your membership has been frozen. You can reactivate it at any time.',
    'İptal talebiniz alınmıştır. 3 iş günü içerisinde işleme alınacaktır.':
        'Your cancellation request has been received. It will be processed within 3 business days.',

    // --- Live Support ---
    'Canlı Destek': 'Live Support',
    'Çevrimiçi': 'Online',
    'Merhaba! İzge Uygulaması Destek Hattına hoş geldiniz. Size nasıl yardımcı olabilirim?':
        'Hello! Welcome to İzge App Support Line. How can I help you?',
    'Talebiniz alınmıştır. Destek ekibimiz şu an yoğun olduğu için size birazdan dönüş yapacaktır. Anlayışınız için teşekkür ederiz.':
        'Your request has been received. Our support team is currently busy and will get back to you shortly. Thank you for your understanding.',
    'Mesajınızı yazın...': 'Type your message...',

    // --- Donation Transparency ---
    'Bağışlar Nereye Gidiyor?': 'Where Do Donations Go?',
    'Şeffaflık ilkemiz gereği, desteklerinizin her bir kuruşunun nasıl değere dönüştüğünü sizlerle paylaşıyoruz.':
        'In line with our transparency principle, we share with you how every penny of your support is converted into value.',
    'Tıbbi Cihazlar': 'Medical Devices',
    'Hayati ekipman alımları': 'Vital equipment purchases',
    'Eğitim': 'Education',
    'Burslar ve eğitim materyalleri': 'Scholarships and educational materials',
    'Danışmanlık': 'Consultancy',
    'Psikolojik ve hukuki destek': 'Psychological and legal support',
    'Yönetim & Operasyon': 'Management & Operations',
    'Kurumsal sürdürülebilirlik için minimum seviyede tutulmaktadır.':
        'Kept at a minimum level for organizational sustainability.',
    'Detaylı Şeffaflık Raporu': 'Detailed Transparency Report',
    'Bağımsız denetim kuruluşları tarafından hazırlanan yıllık faaliyet raporlarımızı inceleyebilirsiniz.':
        'You can review our annual activity reports prepared by independent audit firms.',
    'Raporu İndir': 'Download Report',

    // --- Request Status ---
    'Talep Durumu Sorgulama': 'Request Status Query',
    'Daha önce oluşturduğunuz bir talebin güncel durumunu öğrenmek için talep numaranızı aşağıya giriniz.':
        'Enter your request number below to find out the current status of a request you previously created.',
    'Talep Numarası (Örn: TLP-12345)': 'Request Number (e.g. TLP-12345)',
    'Sorgulanıyor...': 'Querying...',
    'Sorgula': 'Query',
    'Talep Numaramı Nereden Bulabilirim?':
        'Where Can I Find My Request Number?',
    "Talebinizi oluşturduğunuzda size gönderilen onay e-postasında veya SMS mesajında 'TLP-' ile başlayan numaranızı bulabilirsiniz.":
        "You can find your number starting with 'TLP-' in the confirmation email or SMS sent to you when you created your request.",
    'ÖRNEK SONUÇ': 'SAMPLE RESULT',
    'Tekerlekli Sandalye Bakımı': 'Wheelchair Maintenance',
    'Oluşturulma: 12 Ekim 2023': 'Created: October 12, 2023',
    'İşlemde': 'In Progress',
    'Alındı': 'Received',
    'Değerlendirmede': 'Under Review',
    'Onay': 'Approval',
    'Tamamlandı': 'Completed',
    'Güncelleme: ': 'Update: ',
    'Talebiniz ilgili uzman ekibimize iletilmiştir. İnceleme süreci devam etmektedir.':
        'Your request has been forwarded to our relevant expert team. The review process is ongoing.',

    // --- New Request Types ---
    'Yeni Talep Türleri': 'New Request Types',
    'Tıbbi Cihaz Desteği': 'Medical Device Support',
    'Tekerlekli sandalye, işitme cihazı ve diğer medikal ihtiyaçlar.':
        'Wheelchairs, hearing aids, and other medical needs.',
    'Psikolojik Danışmanlık': 'Psychological Counseling',
    'Uzman psikologlardan ücretsiz terapi ve destek seansları.':
        'Free therapy and support sessions from expert psychologists.',
    'Eğitim Bursu': 'Education Scholarship',
    'Öğrenciler için aylık burs veya kırtasiye/materyal yardımı.':
        'Monthly scholarship or stationery/material aid for students.',
    'Hukuki Yardım': 'Legal Aid',
    'Pro bono avukatlarımızdan hukuki danışmanlık hizmeti.':
        'Legal consultancy service from our pro bono lawyers.',
    'Gerekli Belgeler Rehberi': 'Required Documents Guide',
    'Tıbbi Cihaz başvuruları için doktor raporu zorunludur.':
        'A doctor\'s report is required for Medical Device applications.',
    'Eğitim bursu için güncel öğrenci belgesi ve gelir beyanı eklenmelidir.':
        'A current student certificate and income declaration must be attached for education scholarships.',
    'Hukuki yardım taleplerinde vaka özeti PDF veya JPEG formatında yüklenebilir.':
        'For legal aid requests, a case summary can be uploaded in PDF or JPEG format.',

    // --- Connection Issues ---
    'Uygulama ile ilgili bağlantı problemlerini çözmek için aşağıdaki adımları kontrol edebilirsiniz.':
        'You can check the steps below to resolve connection problems regarding the application.',
    'İnternet Bağlantısı Kontrolü': 'Internet Connection Check',
    'Cihazınızın aktif bir Wi-Fi veya hücresel veri ağına bağlı olduğundan emin olun. Tarayıcınız üzerinden bir web sitesi açarak bağlantınızı test edebilirsiniz.':
        'Make sure your device is connected to an active Wi-Fi or cellular data network. You can test your connection by opening a website through your browser.',
    'Modeminizi yeniden başlatın.': 'Restart your modem.',
    'Hücresel veriyi kapatıp açın.': 'Turn cellular data off and on.',
    'Uçak modunun kapalı olduğunu doğrulayın.':
        'Verify that airplane mode is turned off.',
    'Veri Senkronizasyonu': 'Data Synchronization',
    'Bilgileriniz güncellenmiyorsa, manuel senkronizasyon yapmayı deneyin. Ayarlar menüsünden \'Şimdi Senkronize Et\' seçeneğini kullanabilirsiniz.':
        'If your information is not updating, try to synchronize manually. You can use the \'Sync Now\' option from the Settings menu.',
    'Sunucu Durumu': 'Server Status',
    'Bazen sorun bizim tarafımızda olabilir. Planlı bakım veya sunucu kesintileri durumunda sosyal medya hesaplarımızdan duyuru yapmaktayız.':
        'Sometimes the problem may be on our end. We post announcements on our social media accounts in case of planned maintenance or server outages.',
    'Sorun devam ediyor mu?': 'Does the problem persist?',

    // --- Device Compatibility ---
    'Cihaz Uyumluluğu': 'Device Compatibility',
    'Mevcut Versiyon': 'Current Version',
    'İzge App v1.0.4 (Güncel)': 'Izge App v1.0.4 (Current)',
    'Sistem Gereksinimleri': 'System Requirements',
    'En iyi deneyim için cihazınızın aşağıdaki işletim sistemlerinden birini desteklediğinden emin olun.':
        'For the best experience, make sure your device supports one of the following operating systems.',
    'Android 8.0 (Oreo) ve üzeri sürümler önerilir.':
        'Android 8.0 (Oreo) and above are recommended.',
    'iOS 13 ve üzeri sürümler önerilir.': 'iOS 13 and above are recommended.',
    'Performans Bildirimi': 'Performance Notification',
    'Uygulamamız, düşük donanımlı cihazlarda dahi akıcı çalışacak şekilde optimize edilmiştir. Ancak eski işletim sistemlerinde bazı modern grafiksel geçişler otomatik olarak devre dışı bırakılabilir.\n\nEğer cihazınızda donma veya yavaşlama hissediyorsanız, arka planda çalışan diğer uygulamaları kapatmayı deneyebilirsiniz.':
        'Our application is optimized to run smoothly even on low-end devices. However, some modern graphical transitions may be automatically disabled on older operating systems.\n\nIf you experience freezing or slowness on your device, you can try closing other applications running in the background.',

    // --- Other Issues ---
    'Diğer Sorunlar': 'Other Issues',
    'Aradığınız sorunu bulamadıysanız aşağıdaki form ile bize ulaşabilirsiniz. Ekibimiz en kısa sürede size dönüş yapacaktır.':
        'If you could not find the problem you were looking for, you can contact us using the form below. Our team will get back to you as soon as possible.',
    'Konu Başlığı': 'Subject Heading',
    'Lütfen bir konu seçin...': 'Please select a subject...',
    'Hesap İşlemleri ve Profil': 'Account Transactions and Profile',
    'Etkinlik Katılımı / İptali': 'Event Participation / Cancellation',
    'Bağış ve Ödeme Sorunları': 'Donation and Payment Issues',
    'Uygulama İçi Hata (Bug)': 'In-App Error (Bug)',
    'Farklı Bir Konu': 'A Different Topic',
    'Detaylı Açıklama': 'Detailed Explanation',
    'Yaşadığınız sorunu, ne yaparken karşılaştığınızı ve ek detayları buraya yazabilirsiniz...':
        'You can write the problem you are experiencing, what you were doing when you encountered it, and additional details here...',
    'Ekran Görüntüsü Ekle': 'Add Screenshot',
    'İsteğe bağlı, max 5MB': 'Optional, max 5MB',

    // --- Forgot Password Support ---
    'Şifre Sıfırlama': 'Password Reset',
    'Lütfen hesabınıza kayıtlı e-posta adresinizi girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.':
        'Please enter your registered email address. We will send you a password reset link.',
    'Bağlantı Gönder': 'Send Link',
    'Giriş Ekranına Dön': 'Return to Login Screen',

    // --- Forgot Password Failed ---
    'Bağlantı Gönderilemedi': 'Link Could Not Be Sent',
    'Bir hata oluştuğu için şifre sıfırlama bağlantısı e-posta adresinize gönderilemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.':
        'A password reset link could not be sent to your email address because an error occurred. Please check your internet connection and try again.',
    'Deneniyor...': 'Retrying...',
    'Tekrar Dene': 'Try Again',

    // --- Email Verification Support & Failed ---
    'E-posta Doğrulama': 'Email Verification',
    'E-posta adresinize gönderilen 6 haneli doğrulama kodunu giriniz.':
        'Enter the 6-digit verification code sent to your email address.',
    'Doğrula': 'Verify',
    'Doğrulama Başarısız': 'Verification Failed',
    'Doğrulama kodu geçersiz veya süresi dolmuş olabilir. Lütfen kodunuzu kontrol edin veya yeni bir kod talep edin.':
        'The verification code may be invalid or expired. Please check your code or request a new one.',
    'Kodun Süresi Doldu': 'Code Expired',
    'Güvenliğiniz için kodlar 5 dakika geçerlidir.':
        'For your security, codes are valid for 5 minutes.',
    'Yeni Kod Gönder': 'Send New Code',
    'Geri Dön': 'Go Back',

    // --- Account Recovery ---
    'Hesap Kurtarma': 'Account Recovery',
    'Güvenliğiniz için kimliğinizi doğrulamamız gerekiyor. Lütfen aşağıdaki yöntemlerden birini seçin.':
        'We need to verify your identity for your security. Please select one of the following methods.',
    'E-posta ile Doğrulama': 'Verification by Email',
    'Sistemde kayıtlı e-posta adresinizle':
        'With your registered email address in the system',
    'Kayıtlı Telefon Numarası ile SMS': 'SMS with Registered Phone Number',
    'Kayıtlı numaranıza kod gönderilir':
        'A code is sent to your registered number',
    'Destek Merkezi ile İletişime Geç': 'Contact Support Center',

    // --- Additional Support & Question Details ---
    'Destek Merkezi': 'Support Center',
    'Soru Detayı': 'Question Details',
    'Son Güncelleme': 'Last Update',
    '2 gün önce': '2 days ago',
    'İzge App üzerinden yeni bir talep oluşturmak oldukça basit ve hızlı bir işlemdir. Topluluğumuzla ilgili her türlü ihtiyacınızı veya önerinizi bu sistem üzerinden bize iletebilirsiniz. İşlemi tamamlamak için aşağıdaki adımları sırasıyla takip ediniz:':
        'Creating a new request via Izge App is very simple and fast. You can send any kind of need or suggestion regarding our community to us through this system. To complete the process, please follow the steps below in order:',
    'Adım Adım Talep Oluşturma': 'Step-by-Step Request Creation',
    'Talep Durumunu Takip Etme': 'Tracking Request Status',
    'Talebinizi oluşturduktan sonra, "Talepler" sekmesi altındaki "Geçmiş Taleplerim" listesinden sürecin hangi aşamada olduğunu takip edebilirsiniz. Talebiniz onaylandığında, işleme alındığında ve çözümlendiğinde size anlık bildirim (push notification) olarak bilgi verilecektir.\n\nEğer oluşturduğunuz bir talebi iptal etmek isterseniz, talep detay sayfasına girerek "Talebi İptal Et" seçeneğini kullanabilirsiniz. Ancak işleme alınmış talepler iptal edilememektedir.':
        'After creating your request, you can follow which stage of the process is at from the "My Past Requests" list under the "Requests" tab. When your request is approved, processed, and resolved, you will be informed as an instant notification (push notification).\n\nIf you want to cancel a request you have created, you can use the "Cancel Request" option by entering the request detail page. However, requests that have already been processed cannot be cancelled.',
    'Bu makale yardımcı oldu mu?': 'Was this article helpful?',
    'Evet': 'Yes',
    'Hayır': 'No',
    'Talep Detayları': 'Request Details',
    'Lütfen ihtiyacınız olan destek türünü ve detaylarını eksiksiz doldurunuz.':
        'Please fill out the type and details of support you need completely.',
    'Kategori Seçimi': 'Category Selection',
    'Kategori seçiniz': 'Select category',
    'Talep Başlığı': 'Request Title',
    'Örn: Tekerlekli Sandalye İhtiyacı': 'e.g. Wheelchair Need',
    'Durumunuzu ve ihtiyacınızı detaylı bir şekilde açıklayınız...':
        'Explain your situation and need in detail...',
    'Gerekli Belgeler (İsteğe Bağlı)': 'Required Documents (Optional)',
    'Belge Yüklemek İçin Tıklayın': 'Click to Upload Document',
    'Öğrenci belgesi, doktor raporu vb. (Max 5MB)':
        'Student certificate, medical report, etc. (Max 5MB)',
    'Talebi Gönder': 'Submit Request',
    'Talebiniz başarıyla oluşturuldu! (TLP-10492)':
        'Your request has been successfully created! (TLP-10492)',
    'Lütfen bir talep kategorisi seçiniz.': 'Please select a request category.',
    'Başlık zorunludur': 'Title is required',
    'Açıklama zorunludur': 'Description is required',
    'Sık karşılaşılan sorunlar için aşağıdaki çözüm adımlarını inceleyin.':
        'Review the solution steps below for common problems.',
    'Sorununuzu arayın...': 'Search your problem...',
    'Belge yükleme hatası alıyorum': 'I get a document upload error',
    'İnternet bağlantınızı kontrol edin.': 'Check your internet connection.',
    'Belge boyutunun 5MB\'ı aşmadığından emin olun.':
        'Make sure the document size does not exceed 5MB.',
    'Desteklenen formatlarda (PDF, JPG, PNG) yükleme yaptığınızı doğrulayın.':
        'Verify that you are uploading in supported formats (PDF, JPG, PNG).',
    'Uygulamayı kapatıp tekrar açmayı deneyin.':
        'Try closing and reopening the app.',
    'Uygulama donma veya çökme sorunu': 'App freezing or crashing issue',
    'Uygulamanın güncel sürümünü kullandığınızdan emin olun (App Store veya Google Play\'i kontrol edin).':
        'Make sure you are using the latest version of the app (check App Store or Google Play).',
    'Cihazınızda yeterli depolama alanı olduğundan emin olun.':
        'Make sure you have enough storage space on your device.',
    'Cihazınızın ayarlarından uygulama önbelleğini temizleyin.':
        'Clear the app cache from your device settings.',
    'Sorun devam ederse uygulamayı silip yeniden yükleyin.':
        'If the problem persists, uninstall and reinstall the app.',
    'Adres doğrulama problemi': 'Address verification problem',
    'Cihazınızın konum servislerinin açık olduğundan emin olun.':
        'Make sure your device location services are turned on.',
    'Uygulamaya konum erişim izni verdiğinizi kontrol edin (Ayarlar > İzge App > Konum).':
        'Check that you have granted location access to the app (Settings > İzge App > Location).',
    'Manuel adres girerken posta kodunuzu doğru yazdığınızdan emin olun.':
        'Make sure you write your zip code correctly when entering manual address.',
    'Hala sorun mu yaşıyorsunuz?': 'Are you still experiencing problems?',
    'Destek ekibimiz size yardımcı olmak için burada.':
        'Our support team is here to help you.',

    // --- Donate Screen ---
    'Tek Seferlik': 'One-Time',
    'Aylık Düzenli': 'Monthly Regular',
    'Nereye Destek Olmak İstersiniz?': 'Where Would You Like to Support?',
    'Genel Bağış': 'General Donation',
    'Tekerlekli Sandalye': 'Wheelchair',
    'Gıda Paketi': 'Food Package',
    'Bağış Miktarı': 'Donation Amount',
    'Diğer Miktar': 'Other Amount',
    'Aylık Bağışı Başlat': 'Start Monthly Donation',
    'Bağışı Tamamla': 'Complete Donation',
    'Aylık düzenli bağışlarınız, her ayın aynı gününde kartınızdan otomatik olarak çekilecektir. İstediğiniz zaman iptal edebilirsiniz.':
        'Your regular monthly donations will be automatically debited from your card on the same day of each month. You can cancel at any time.',
    'Yukarıdaki butona tıklayarak Aydınlatma Metni\'ni okuduğunuzu ve kabul ettiğinizi onaylamış olursunuz.':
        'By clicking the button above, you confirm that you have read and accepted the Clarification Text.',

    // --- Events Screen ---
    'Ekim 2023': 'October 2023',
    'Günün Etkinlikleri': "Day's Events",
    'Bugün, 12 Ekim': 'Today, October 12',
    'Etkinlikler yüklenirken hata oluştu: ':
        'An error occurred while loading events: ',
    'Henüz planlanmış bir etkinlik yok': 'No events planned yet',

    'Bağla': 'Link',
  };
}

extension LocalizationExtension on String {
  String tr() {
    return LanguageController.instance.translate(this);
  }
}
