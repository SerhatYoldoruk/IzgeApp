-- info_cards tablosu
CREATE TABLE IF NOT EXISTS public.info_cards (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT NOT NULL,
  summary     TEXT NOT NULL,
  content     TEXT NOT NULL,
  category    TEXT NOT NULL DEFAULT 'genel',
  color_hex   TEXT NOT NULL DEFAULT '#1A8025',
  icon_name   TEXT NOT NULL DEFAULT 'info',
  is_active   BOOLEAN NOT NULL DEFAULT true,
  sort_order  INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS
ALTER TABLE public.info_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "info_cards_public_read" ON public.info_cards FOR SELECT USING (is_active = true);

-- 3 başlangıç kaydı
INSERT INTO public.info_cards (title, summary, content, category, color_hex, icon_name, sort_order) VALUES
(
  'Nöroçeşitlilik',
  'İnsan beyninin farklı şekillerde işlev gösterebileceğini kabul eden bir yaklaşım.',
  'Nöroçeşitlilik, otizm, DEHB ve disleksi gibi nörolojik farklılıkların birer "bozukluk" değil, insan beyninin doğal çeşitliliğinin bir parçası olduğunu savunur.

Bu yaklaşıma göre farklı düşünce biçimleri, topluma özgün katkılar sağlar. Nöroçeşitlilik perspektifi, bireyleri eksiklik üzerinden değil güçlü yönleri üzerinden tanımlar.

Nörogelişimsel farklılıklar, doğru destekle bireylerin potansiyellerini tam anlamıyla ortaya koymasına imkân tanır. Kabul, anlayış ve uygun düzenlemeler bu süreçte belirleyici rol oynar.',
  'norocesitlilik',
  '#6B4FA0',
  'psychology',
  1
),
(
  'Otizm Spektrum Bozukluğu',
  'Sosyal iletişimde farklılıklar ve tekrarlayan davranış örüntüleriyle kendini gösteren nörogelişimsel bir farklılık.',
  'Otizm spektrum bozukluğu (OSB), sosyal iletişim ve etkileşimde farklılıklar ile kısıtlı ve tekrarlayan davranış örüntüleriyle kendini gösteren nörogelişimsel bir durumdur.

Her otizmli birey benzersizdir. "Spektrum" kavramı tam da bunu ifade eder: bazı bireyler yoğun destek ihtiyacı duyarken bazıları bağımsız bir yaşam sürebilir.

Erken tanı ve müdahale son derece kritiktir. Uygun destek programları, bireylerin iletişim becerilerini, sosyal katılımını ve bağımsızlığını önemli ölçüde geliştirebilir. Otizmli bireyler, doğru ortam ve destekle toplumun her alanına katkı sağlayabilir.',
  'otizm',
  '#1A6B8A',
  'diversity_3',
  2
),
(
  'Down Sendromu',
  '21. kromozomun fazladan bir kopyasına sahip olunmasıyla oluşan genetik bir durum.',
  'Down sendromu, hücrelerde 21. kromozomun üç kopya halinde bulunmasıyla (trizomi 21) oluşan genetik bir durumdur. Yaklaşık her 700-800 doğumdan birinde görülür.

Down sendromlu bireyler öğrenebilir, çalışabilir, sanat üretebilir ve topluma aktif olarak katılabilir. Gelişim hızları farklılık gösterse de her birey kendi temposunda büyür ve gelişir.

Erken başlayan eğitim programları, fizik tedavi, konuşma terapisi ve sosyal destek; bireylerin bağımsızlıklarını ve yaşam kalitelerini artırmada belirleyici rol oynar. Doğru destekle Down sendromlu bireyler anlamlı ve dolu bir yaşam sürebilir.',
  'down_sendromu',
  '#1A8025',
  'favorite',
  3
);
