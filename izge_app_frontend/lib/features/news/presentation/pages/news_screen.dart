import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/navigation/presentation/widgets/custom_drawer.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_detail_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_bloc.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_state.dart';
import 'package:izge_app_frontend/core/models/announcement_model.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_event.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
class NewsItem {
  final String tag;
  final Color tagColor;
  final String date;
  final String title;
  final String description;
  final String imageUrl;

  NewsItem({
    required this.tag,
    required this.tagColor,
    required this.date,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  int _visibleCount = 3;
  bool _isLoadingMore = false;
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR');
    LanguageController.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageController.instance.removeListener(_onLanguageChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _visibleCount += 2;
        _isLoadingMore = false;
      });
    }
  }

  List<AnnouncementModel> _filteredNews(List<AnnouncementModel> allNews) {
    return allNews.where((news) {
      final matchesSearch = news.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            news.content.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesCategory = true;
      // You could map categories here if AnnouncementModel has a category field.
      // For now we map basic logic.
      if (_selectedCategory == 'Duyurular') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Etkinlikler') {
        matchesCategory = false; // Need event endpoint
      } else if (_selectedCategory == 'Projeler') {
        matchesCategory = false;
      }
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              )
            : Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                }
              ),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/images/images/logo.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'İzge App',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () async {
          context.read<NewsBloc>().add(NewsFetchRequested());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Haberler ve Duyurular'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Dernekten en güncel haberler'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Haberlerde ara...'.tr(),
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tümü'.tr(), 
                    isSelected: _selectedCategory == 'Tümü',
                    onTap: () => setState(() => _selectedCategory = 'Tümü'),
                  ),
                  _FilterChip(
                    label: 'Duyurular'.tr(), 
                    isSelected: _selectedCategory == 'Duyurular',
                    onTap: () => setState(() => _selectedCategory = 'Duyurular'),
                  ),
                  _FilterChip(
                    label: 'Etkinlikler'.tr(), 
                    isSelected: _selectedCategory == 'Etkinlikler',
                    onTap: () => setState(() => _selectedCategory = 'Etkinlikler'),
                  ),
                  _FilterChip(
                    label: 'Projeler'.tr(), 
                    isSelected: _selectedCategory == 'Projeler',
                    onTap: () => setState(() => _selectedCategory = 'Projeler'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // News Feed List
            BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (state is NewsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 48, color: AppColors.textSecondary),
                          const SizedBox(height: 16),
                          Text(
                            LanguageController.instance.isTurkish 
                              ? 'Bağlantı hatası. Lütfen internetinizi kontrol edin.'
                              : 'Connection error. Please check your internet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is NewsLoaded) {
                  final filteredNews = _filteredNews(state.news);
                  final displayedNews = filteredNews.take(_visibleCount).toList();
                  final hasMore = filteredNews.length > _visibleCount;

                  if (displayedNews.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface, // surface-container
                              border: Border.all(color: AppColors.border.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7ADC75).withOpacity(0.15),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.newspaper,
                                size: 48,
                                color: Color(0xFF7ADC75), // primary
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Haber Bulunamadı'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aradığınız kriterlere uygun haber veya duyuru bulunmuyor. Farklı bir arama yapmayı deneyebilirsiniz.'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                  _selectedCategory = 'Tümü';
                                });
                              },
                              icon: const Icon(Icons.refresh, color: Color(0xFFD3FFC8)),
                              label: Text(
                                'Tüm Haberleri Gör'.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD3FFC8),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A8025), // primary-container
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      ...displayedNews.map((news) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: _AdvancedNewsCard(
                            tag: 'DUYURU'.tr(), // Or dynamic depending on category
                            tagColor: AppColors.accentDark,
                            date: DateFormat('dd MMM yyyy', LanguageController.instance.isTurkish ? 'tr_TR' : 'en_US').format(news.createdAt),
                            title: news.title,
                            description: news.content,
                            imageUrl: news.imageUrl ?? 'https://via.placeholder.com/400x200?text=Izge',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news)),
                              );
                            },
                          ),
                        );
                      }),
                      
                      // Load More Button
                      if (hasMore)
                        ElevatedButton.icon(
                          onPressed: _isLoadingMore ? null : _loadMore,
                          icon: _isLoadingMore 
                              ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                              : Icon(Icons.refresh, color: AppColors.accent),
                          label: Text(
                            _isLoadingMore ? 'Yükleniyor...'.tr() : 'Daha Fazla Yükle'.tr(), 
                            style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            elevation: 0,
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox();
              }
            ),
            const SizedBox(height: 60), // Space for bottom nav
          ],
        ),
      ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label, 
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.accent : AppColors.surface,
          foregroundColor: isSelected ? Colors.black : AppColors.textSecondary,
          elevation: isSelected ? 8 : 0,
          shadowColor: isSelected ? AppColors.accent.withOpacity(0.4) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: isSelected ? BorderSide.none : BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          minimumSize: const Size(0, 44),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14,
            color: isSelected ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AdvancedNewsCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String date;
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const _AdvancedNewsCard({
    required this.tag,
    required this.tagColor,
    required this.date,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: AppColors.surface.withOpacity(0.5),
                      child: Center(
                        child: Icon(Icons.image_not_supported, color: AppColors.textSecondary),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Devamını Oku'.tr(),
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.accent,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
