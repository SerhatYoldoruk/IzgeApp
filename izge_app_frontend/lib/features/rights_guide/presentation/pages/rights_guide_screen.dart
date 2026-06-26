import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'rights_guide_detail_screen.dart';

class RightsGuideScreen extends StatefulWidget {
  const RightsGuideScreen({super.key});

  @override
  State<RightsGuideScreen> createState() => _RightsGuideScreenState();
}

class _RightsGuideScreenState extends State<RightsGuideScreen> {
  List<Map<String, dynamic>> _allGuides = [];
  String _selectedFilter = 'all';
  bool _loading = true;

  final List<Map<String, String>> _disabilityFilters = [
    {'key': 'all', 'label': 'Tümü'},
    {'key': 'autism', 'label': 'Otizm'},
    {'key': 'intellectual', 'label': 'Zihinsel Engel'},
    {'key': 'physical', 'label': 'Fiziksel Engel'},
    {'key': 'visual', 'label': 'Görme Engeli'},
    {'key': 'hearing', 'label': 'İşitme Engeli'},
    {'key': 'chronic', 'label': 'Süreğen Hastalık'},
    {'key': 'learning', 'label': 'Öğrenme Güçlüğü'},
    {'key': 'language', 'label': 'Dil/Konuşma'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/rights_guide_data.json');
      final List<dynamic> decoded = json.decode(jsonStr);
      setState(() {
        _allGuides = decoded.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      debugPrint('Rehber verisi yüklenemedi: $e');
      setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredGuides {
    if (_selectedFilter == 'all') return _allGuides;
    return _allGuides.where((g) {
      final types = (g['disabilityTypes'] as List).cast<String>();
      return types.contains('all') || types.contains(_selectedFilter);
    }).toList();
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'medical_services': return Icons.medical_services;
      case 'payments': return Icons.payments;
      case 'directions_car': return Icons.directions_car;
      case 'local_parking': return Icons.local_parking;
      case 'school': return Icons.school;
      case 'gavel': return Icons.gavel;
      case 'directions_bus': return Icons.directions_bus;
      case 'home': return Icons.home;
      default: return Icons.info;
    }
  }

  Color _getColor(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanHex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Haklar Rehberi'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Column(
              children: [
                // Engel türü filtreleri
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _disabilityFilters.map((filter) {
                        final isSelected = _selectedFilter == filter['key'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter['label']!),
                            selected: isSelected,
                            selectedColor: AppColors.accent,
                            backgroundColor: AppColors.surfaceElevated,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedFilter = filter['key']!);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Bilgilendirme banner
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.accent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Engel türünüze göre filtreleyerek size özel hakları görüntüleyebilirsiniz.'.tr(),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Rehber kartları
                Expanded(
                  child: _filteredGuides.isEmpty
                      ? Center(
                          child: Text(
                            'Bu engel türü için rehber bulunamadı.'.tr(),
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: _filteredGuides.length,
                          itemBuilder: (context, index) {
                            final guide = _filteredGuides[index];
                            final color = _getColor(guide['color']);
                            final icon = _getIcon(guide['icon']);
                            final stepsCount = (guide['steps'] as List).length;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RightsGuideDetailScreen(guide: guide),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(icon, color: color, size: 26),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              guide['title'],
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '$stepsCount adım · Detaylı rehber'.tr(),
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: AppColors.textSecondary, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
