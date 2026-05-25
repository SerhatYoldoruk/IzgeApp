import '../domain/models/news_article.dart';

class NewsRepository {
  const NewsRepository();

  List<String> get filters => const [
        'Tümü',
        'Duyurular',
        'Etkinlikler',
        'Projeler',
      ];

  List<NewsArticle> get articles => const [
        NewsArticle(
          title: 'Yıllık Genel Kurul Toplantısı',
          date: '12 Ekim 2023',
          summary: 'Derneğimizin yeni dönem hedefleri belirlendi...',
          imageAsset: 'assets/images/images/news_main.png',
          tag: 'Duyuru',
        ),
        NewsArticle(
          title: 'Gelecek İçin Fidan Dikim Etkinliğimiz',
          date: '5 Ekim 2023',
          summary: 'Topluma açık gönüllü etkinliğimiz başarıyla tamamlandı.',
          imageAsset: 'assets/images/images/news_thumb.png',
          tag: 'Etkinlik',
        ),
        NewsArticle(
          title: 'Yeni Toplum Merkezi İnşaatı',
          date: '5 Ekim 2023',
          summary: 'Bölge sakinleri için yeni merkez projesi başlatıldı.',
          imageAsset: 'assets/images/images/news_thumb.png',
          tag: 'Proje',
        ),
      ];
}
