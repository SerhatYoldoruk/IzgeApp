-- ==============================================================================
-- İZGE SOSYAL YARDIMLAŞMA PLATFORMU - SUPABASE SEED DATA (TEST VERİLERİ)
-- Bu kodları Supabase panosundaki "SQL Editor" bölümüne yapıştırıp çalıştırın (RUN).
-- ==============================================================================

-- 1. DUYURULAR (ANNOUNCEMENTS)
INSERT INTO public.announcements (title, content, image_url, is_pinned) VALUES
('Yeni Rehabilitasyon Merkezi Açılıyor', 'İzge Derneği olarak yeni rehabilitasyon merkezimizin inşaatını tamamladık. Önümüzdeki ay açılışını gerçekleştiriyoruz.', 'https://images.unsplash.com/photo-1513159446162-54eb8bdaa79b?q=80&w=600&auto=format&fit=crop', true),
('Gönüllü Eğitmen Başvuruları Başladı', 'Özel eğitim gereksinimi olan çocuklara yönelik yaz dönemi eğitimlerimiz için gönüllü eğitmenler arıyoruz. Başvurularınızı uygulama üzerinden veya web sitemizden yapabilirsiniz.', 'https://images.unsplash.com/photo-1577896851231-70ef18881754?q=80&w=600&auto=format&fit=crop', false),
('Tekerlekli Sandalye Bağış Kampanyası Sonuçlandı', 'Geçtiğimiz ay başlattığımız tekerlekli sandalye bağış kampanyasında hedefimize ulaştık. Destek olan tüm bağışçılarımıza teşekkür ederiz!', 'https://images.unsplash.com/photo-1594047391963-0a257c7d42cf?q=80&w=600&auto=format&fit=crop', false);

-- 2. ETKİNLİKLER (EVENTS)
INSERT INTO public.events (title, description, location, event_date, image_url) VALUES
('Engelsiz Yaşam Buluşması', 'Dernek üyelerimiz ve gönüllülerimizle birlikte düzenlediğimiz bahar şenliği ve piknik organizasyonu.', 'Atatürk Parkı, Ankara', timezone('utc'::text, now() + interval '5 days'), 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?q=80&w=600&auto=format&fit=crop'),
('Farkındalık Semineri', 'Toplumda özel gereksinimli bireylere yönelik farkındalığı artırmak için uzman psikologlarımız eşliğinde gerçekleştireceğimiz seminer.', 'Merkez Ofis Seminer Salonu', timezone('utc'::text, now() + interval '12 days'), 'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?q=80&w=600&auto=format&fit=crop'),
('Sanat Atölyesi Sergisi', 'Çocuklarımızın yıl boyunca sanat atölyesinde hazırladığı el emeği eserlerin sergileneceği özel etkinlik.', 'İzge Sanat Galerisi', timezone('utc'::text, now() + interval '20 days'), 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?q=80&w=600&auto=format&fit=crop');

-- 3. ANKETLER VE SEÇENEKLERİ (POLLS & POLL OPTIONS)
-- Önce çakışmayı önlemek için test ID'lerini temizle
DELETE FROM public.polls WHERE id IN (1, 2);

-- Anket 1 (Aktif)
INSERT INTO public.polls (id, title, description, is_active, starts_at, ends_at, expires_at) OVERRIDING SYSTEM VALUE VALUES 
(1, 'Gelecek Ayın Eğitim Konusu Ne Olsun?', 'Üyelerimizin ihtiyaçlarına göre gelecek ayın online eğitim semineri konusunu belirliyoruz.', true, timezone('utc'::text, now()), timezone('utc'::text, now() + interval '7 days'), timezone('utc'::text, now() + interval '7 days'));

INSERT INTO public.poll_options (poll_id, option_text) VALUES 
(1, 'Aile İçi İletişim'),
(1, 'Fiziksel Terapi Yöntemleri'),
(1, 'Hukuki Haklar ve Danışmanlık');

-- Anket 2 (Aktif Değil - Geçmiş)
INSERT INTO public.polls (id, title, description, is_active, starts_at, ends_at, expires_at) OVERRIDING SYSTEM VALUE VALUES 
(2, 'Yaz Kampı Nerede Yapılsın?', 'Geleneksel yaz kampımızın yapılacağı bölgeyi seçiyoruz.', false, timezone('utc'::text, now() - interval '20 days'), timezone('utc'::text, now() - interval '10 days'), timezone('utc'::text, now() - interval '10 days'));

INSERT INTO public.poll_options (poll_id, option_text) VALUES 
(2, 'Antalya Kamp Alanı'),
(2, 'İzmir Doğa Köyü'),
(2, 'Bolu Orman Kampı');
