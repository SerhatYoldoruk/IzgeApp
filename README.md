# İzge App 💙

İzge App, otizmli ve özel gereksinimli çocukların aileleri için geliştirilmiş, hayatı kolaylaştıran kapsamlı bir mobil uygulamadır. Gelişim takibinden yasal haklara, kriz yönetimi asistanından topluluk yardımlaşma ağına kadar birçok aracı tek bir çatı altında sunar.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-181818?style=for-the-badge&logo=supabase&logoColor=green)
![CI/CD](https://img.shields.io/github/actions/workflow/status/yourusername/izge_app_frontend/flutter_ci.yml?style=for-the-badge&label=CI/CD)

## 🌟 Temel Özellikler

* **Kriz (Meltdown) Yönetim Asistanı:** Çocuğun duyusal kriz anlarında ebeveynlerin doğru adımları atmasını sağlayan ipuçları, görsel nefes egzersizleri, zamanlayıcı sayaçlar ve rahatlatıcı ses altyapısı.
* **Gelişim Takibi:** Çocuğunuzun günlük gelişimini, rutinlerini ve kilometre taşlarını not edip izleyebileceğiniz özel araç.
* **Haklar Rehberi:** Özel gereksinimli bireylerin ve ailelerinin yasal haklarını, destekleri ve izlenmesi gereken resmi süreçleri sadeleştiren bilgilendirme merkezi.
* **Eğitim Oyunları ve Etkinlikler:** Çocuğunuzun evde gelişimini destekleyecek uzman onaylı günlük aktivite önerileri.
* **Topluluk & Yardım Ağı:** Diğer ailelerle iletişim kurabileceğiniz, deneyimlerinizi paylaşabileceğiniz kapalı ve güvenli forum platformu.
* **Karanlık / Aydınlık Mod ve Çoklu Dil Desteği:** Kullanıcı dostu erişilebilir arayüz.

## 🛠️ Kullanılan Teknolojiler

* **Frontend:** Flutter & Dart
* **State Management:** BLoC (Business Logic Component) Pattern
* **Backend:** Supabase (PostgreSQL, Auth, Storage)
* **API İletişimi:** http & Supabase Client
* **CI/CD:** GitHub Actions (Otomatik analiz ve testler)

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

1. **Depoyu klonlayın:**
   ```bash
   git clone https://github.com/yourusername/izge_app_frontend.git
   ```

2. **Proje klasörüne gidin:**
   ```bash
   cd izge_app_frontend
   ```

3. **Gerekli paketleri indirin:**
   ```bash
   flutter pub get
   ```

4. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

*(Not: Çevresel değişkenler (.env) veya Supabase konfigürasyonları için proje yöneticisiyle iletişime geçin.)*

## 🔄 CI/CD Süreci

Bu depo, her "push" veya "pull request" işleminde GitHub Actions tarafından denetlenmektedir.
- Kod kalitesi (`flutter analyze`) kontrol edilir.
- Mevcut birim testleri (`flutter test`) otomatik olarak çalıştırılır.
Herhangi bir hata varsa GitHub üzerinde kırmızı işaret ile belirtilir ve kod kalitesi korunur.

## 📄 Lisans
Bu proje özel telif haklarına tabidir ve izinsiz kopyalanamaz veya çoğaltılamaz.
