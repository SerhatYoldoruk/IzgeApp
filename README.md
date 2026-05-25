# Izge App

Izge App, tek bir Git deposu altında toplanmış bir backend + mobil uygulama projesidir. Bu repo, geliştirme ve yayınlama süreçlerini tek merkezden yönetmek için düzenlenmiştir.

## Proje Yapısı

- `izge_app_backend/`: Supabase migrasyonları, policy dosyaları ve backend ile ilgili ayarlar
- `izge_app_frontend/`: Flutter / Dart tabanlı mobil uygulama

## Teknik Özellikler

- Frontend Flutter ile yazılmıştır.
- Backend tarafında Supabase SQL migrasyonları ve güvenlik policy'leri yer alır.
- Repo yapısı tek kök Git deposu olacak şekilde düzenlenmiştir.

## Kurulum

### 1. Depoyu klonla

```bash
git clone <repo-url>
cd izge_app
```

### 2. Frontend bağımlılıklarını yükle

```bash
cd izge_app_frontend
flutter pub get
```

### 3. Uygulamayı çalıştır

İhtiyacın olan platforma göre Flutter komutlarını çalıştır:

```bash
flutter run
```

Gerekirse belirli bir cihaz seçmek için Flutter'ın standart `-d` parametresini kullanabilirsin.

## Backend Notları

Backend klasörü, Supabase tarafında kullanılan SQL dosyalarını içerir. Yeni bir ortam kurarken bu migrasyonların ve policy dosyalarının Supabase projesine uygulanması gerekir.

