import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/core/constants/dummy_info_cards.dart';
import 'info_card_detail_screen.dart';
class InfoCard {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String colorHex;
  final String iconName;
  final int sortOrder;

  const InfoCard({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.colorHex,
    required this.iconName,
    required this.sortOrder,
  });

  factory InfoCard.fromMap(Map<String, dynamic> map) {
    return InfoCard(
      id: map['id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      colorHex: map['color_hex'] as String? ?? '#1A8025',
      iconName: map['icon_name'] as String? ?? 'info',
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  Color get color {
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  IconData get icon {
    switch (iconName) {
      case 'psychology': return Icons.psychology;
      case 'diversity_3': return Icons.diversity_3;
      case 'favorite': return Icons.favorite;
      case 'accessibility': return Icons.accessibility;
      case 'hearing': return Icons.hearing;
      case 'visibility': return Icons.visibility;
      default: return Icons.info_outline;
    }
  }
}

class InfoCardsScreen extends StatefulWidget {
  const InfoCardsScreen({super.key});

  @override
  State<InfoCardsScreen> createState() => _InfoCardsScreenState();
}

class _InfoCardsScreenState extends State<InfoCardsScreen> {
  late Future<List<InfoCard>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = _fetchCards();
  }

  Future<List<InfoCard>> _fetchCards() async {
    final response = await Supabase.instance.client
        .from('info_cards')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);
    
    final dbCards = (response as List).map((e) => InfoCard.fromMap(e)).toList();
    
    // Geçici olarak statik kartları ekleyelim
    return [...dbCards, ...DummyInfoCards.cards];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bilgi Kartları',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<InfoCard>>(
        future: _cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'İçerikler yüklenemedi.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          final cards = snapshot.data ?? [];
          if (cards.isEmpty) {
            return Center(
              child: Text(
                'Henüz bilgi kartı eklenmemiş.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farkındalık & Bilgilendirme',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return _InfoCardTile(card: cards[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCardTile extends StatelessWidget {
  final InfoCard card;
  const _InfoCardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InfoCardDetailScreen(card: card)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: card.color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: card.color.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Icon(card.icon, color: card.color, size: 36),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        card.summary,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Oku',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: card.color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 12, color: card.color),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
