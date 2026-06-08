import 'package:izge_app_frontend/features/info_cards/presentation/pages/info_cards_screen.dart';

class DummyInfoCards {
  static const List<InfoCard> cards = [
    InfoCard(
      id: 'c1',
      title: 'Disleksi Nedir?',
      summary: 'Öğrenme güçlüklerinden biri olan disleksi hakkında bilmeniz gereken temel özellikler ve yaklaşım yolları.',
      content: 'Disleksi, zekadan bağımsız olarak okuma, yazma ve dil becerilerinde yaşanan özgül bir öğrenme güçlüğüdür.\n\nBir hastalık değil, beynin bilgiyi işleme biçimindeki bir farklılıktır. Disleksili bireyler, kelimeleri hecelemekte veya sayıları ters algılamakta zorlanabilirler ancak görsel, analitik veya yaratıcı düşünme yetenekleri genellikle çok yüksektir. Erken teşhis ve bireyselleştirilmiş özel eğitim destekleriyle eğitim hayatlarında büyük başarılar elde edebilirler.',
      category: 'norocesitlilik',
      colorHex: '#8E24AA', // Mor
      iconName: 'psychology',
      sortOrder: 4,
    ),
    InfoCard(
      id: 'c2',
      title: 'Serebral Palsi (CP)',
      summary: 'Gelişimi tamamlanmamış beynin hasar görmesiyle ortaya çıkan Serebral Palsi hakkında genel bilgiler.',
      content: 'Serebral Palsi (Beyin Felci), bebeklik veya çocukluk çağında beynin hasar görmesi sonucu ortaya çıkan, kas hareketlerini ve vücut duruşunu etkileyen fiziksel bir engellilik durumudur.\n\nSerebral Palsi ilerleyici değildir ancak belirtiler zamanla değişebilir. Bireylerin zeka seviyeleri genellikle normal veya normalin üstündedir. Fizik tedavi, ergoterapi ve cihaz destekleriyle CP\'li bireylerin bağımsız yaşam becerileri önemli ölçüde artırılabilir.',
      category: 'hastaliklar',
      colorHex: '#0288D1', // Mavi
      iconName: 'accessibility',
      sortOrder: 5,
    ),
    InfoCard(
      id: 'c3',
      title: 'Erişilebilirlik Neden Önemli?',
      summary: 'Engelli bireylerin sosyal hayata eşit katılımı için fiziksel ve dijital erişilebilirliğin önemi.',
      content: 'Erişilebilirlik, herkesin hiçbir fiziksel veya dijital engelle karşılaşmadan toplumsal hayata tam katılım sağlayabilmesidir.\n\nSadece tekerlekli sandalye rampalarından ibaret değildir; görme engelliler için sesli betimlemeler ve Braille alfabeli yönlendirmeler, işitme engelliler için işaret dili tercümanları, nöroçeşitli bireyler içinse sakin duyusal alanlar sağlanmasını kapsar. Engelleri kaldıran toplumlar, herkes için daha yaşanabilir hale gelir.',
      category: 'farkindalik',
      colorHex: '#FBC02D', // Sarı
      iconName: 'diversity_3',
      sortOrder: 6,
    ),
  ];
}
