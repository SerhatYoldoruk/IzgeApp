import '../domain/models/featured_content.dart';

class HomeRepository {
  const HomeRepository();

  List<FeaturedContent> get featuredContent => const [
        FeaturedContent(
          title: 'Engelsiz Yaşam Buluşması',
          tag: 'ETKİNLİK',
          imageAsset: 'assets/images/images/featured_card.png',
        ),
        FeaturedContent(
          title: 'Yeni Rehabilitasyon Merkezi',
          tag: 'DUYURU',
          imageAsset: 'assets/images/images/featured_card.png',
        ),
      ];
}
