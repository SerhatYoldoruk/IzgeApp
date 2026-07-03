import 'package:izge_app_frontend/core/localization/language_controller.dart';
import '../domain/models/featured_content.dart';

class HomeRepository {
  const HomeRepository();

  List<FeaturedContent> get featuredContent => [
        FeaturedContent(
          title: 'Engelsiz Yaşam Buluşması'.tr(),
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
