# Izge App Backend

Bu klasör Supabase tarafındaki backend düzenini taşır.

## Kapsam

- Veritabanı şeması
- RLS politikaları
- Storage bucket ayarları
- Frontend servis katmanıyla uyumlu SQL yapılandırmaları

## Uygulama Sırası

1. `supabase/migrations/0001_init.sql` dosyasını çalıştır.
2. `supabase/policies/0002_rls.sql` ile RLS kurallarını uygula.
3. `supabase/storage/0003_avatar_bucket.sql` ile avatar bucket'ını oluştur.
4. `supabase/migrations/0004_auth_profile_trigger.sql` ile auth -> profiles trigger'ını ekle.
5. Frontend tarafında `lib/core/config/supabase_config.dart` içindeki URL ve anon key'i kullan.
6. `lib/core/services/supabase_service.dart` içindeki servis çağrılarını bu şemayla eşle.

## Beklenen Tablolar

- `profiles`
- `announcements`
- `events`
- `event_days`
- `polls`
- `poll_options`
- `poll_votes`
- `chat_rooms`
- `messages`

## Notlar

- Bu yapı Supabase merkezlidir; ayrı bir Node/Express server zorunlu değildir.
- Secret service role key frontend'e konmamalıdır.
- Storage yüklemeleri için `avatar` bucket'ı public veya kontrollü policy ile açılmalıdır.
