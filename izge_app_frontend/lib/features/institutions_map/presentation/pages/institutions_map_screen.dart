import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:izge_app_frontend/features/institutions_map/data/services/osm_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class InstitutionModel {
  final String id;
  final String name;
  final String category;
  final LatLng location;
  final String address;
  final String phone;
  final Map<String, bool> accessibility;
  final double rating;
  final int reviewCount;

  InstitutionModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.address,
    required this.phone,
    required this.accessibility,
    required this.rating,
    this.reviewCount = 0,
  });

  factory InstitutionModel.fromOSM(Map<String, dynamic> osmNode) {
    final tags = osmNode['tags'] as Map<String, dynamic>? ?? {};
    String category = 'Diğer';
    if (tags['amenity'] == 'hospital' || tags['amenity'] == 'clinic') {
      category = 'Hastane';
    } else if (tags['leisure'] == 'park') {
      category = 'Park';
    } else if (tags['amenity'] == 'school' || tags['amenity'] == 'kindergarten') {
      category = 'Özel Eğitim';
    } else if (tags['amenity'] == 'social_facility') {
      category = 'Sosyal Tesis';
    }

    bool hasWheelchair = tags['wheelchair'] == 'yes';

    return InstitutionModel(
      id: osmNode['id'].toString(),
      name: tags['name'] ?? 'Bilinmeyen Mekan',
      category: category,
      location: LatLng(osmNode['lat'] as double, osmNode['lon'] as double),
      address: tags['addr:street'] != null 
          ? '${tags['addr:street']} ${tags['addr:housenumber'] ?? ''}'.trim() 
          : 'Adres bilgisi yok',
      phone: tags['phone'] ?? tags['contact:phone'] ?? tags['contact:mobile'] ?? 'Telefon bilgisi yok',
      accessibility: {'wheelchair': hasWheelchair, 'autism_friendly': false},
      rating: 0.0,
      reviewCount: 0,
    );
  }

  InstitutionModel copyWithReviews(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) return this;
    
    double totalRating = 0;
    int autismVotes = 0;
    int wheelchairVotes = 0;

    for (var r in reviews) {
      totalRating += (r['rating'] as num?)?.toDouble() ?? 5.0;
      if (r['is_autism_friendly'] == true) autismVotes++;
      if (r['has_wheelchair_access'] == true) wheelchairVotes++;
    }

    return InstitutionModel(
      id: id,
      name: name,
      category: category,
      location: location,
      address: address,
      phone: phone,
      accessibility: {
        'wheelchair': wheelchairVotes > 0 || accessibility['wheelchair'] == true,
        'autism_friendly': autismVotes > 0,
        'parking': accessibility['parking'] == true,
      },
      rating: totalRating / reviews.length,
      reviewCount: reviews.length,
    );
  }
}

class InstitutionsMapScreen extends StatefulWidget {
  const InstitutionsMapScreen({super.key});

  @override
  State<InstitutionsMapScreen> createState() => _InstitutionsMapScreenState();
}

class _InstitutionsMapScreenState extends State<InstitutionsMapScreen> {
  final MapController _mapController = MapController();
  final OsmService _osmService = OsmService();
  String _selectedCategory = 'Tümü';
  LatLng? _currentPosition;
  bool _isLoading = false;

  final List<String> _categories = [
    'Tümü',
    'Hastane',
    'Park',
    'Özel Eğitim',
    'Sosyal Tesis',
    'Diğer',
  ];

  List<InstitutionModel> _institutions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _loadMapData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final bounds = _mapController.camera.visibleBounds;
      final minLat = bounds.southWest.latitude;
      final minLng = bounds.southWest.longitude;
      final maxLat = bounds.northEast.latitude;
      final maxLng = bounds.northEast.longitude;

      final osmNodes = await _osmService.fetchPlacesInBounds(minLat, minLng, maxLat, maxLng);
      final osmIds = osmNodes.map((n) => n['id'].toString()).toList();

      final reviewsData = await SupabaseService.instance.getPlaceReviews(osmIds: osmIds);

      final List<InstitutionModel> loadedInstitutions = [];
      for (var node in osmNodes) {
        var inst = InstitutionModel.fromOSM(node);
        
        final nodeReviews = reviewsData.where((r) => r['osm_id'] == inst.id).toList();
        inst = inst.copyWithReviews(nodeReviews);
        
        loadedInstitutions.add(inst);
      }

      if (mounted) {
        setState(() {
          _institutions = loadedInstitutions;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mekanlar yüklenirken hata oluştu: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konum servisleri kapalı.'.tr())));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konum izni reddedildi.'.tr())));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konum izinleri kalıcı olarak reddedilmiş.'.tr())));
      return;
    }

    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konum bulunuyor...'.tr())));
    
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konum alınamadı: $e')));
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Hastane': return Icons.local_hospital;
      case 'Terapi Merkezi': return Icons.psychology;
      case 'Özel Eğitim': return Icons.school;
      case 'Spor Tesisi': return Icons.sports_basketball;
      case 'Sosyal Tesis': return Icons.people;
      default: return Icons.place;
    }
  }

  List<InstitutionModel> get _filteredInstitutions {
    if (_selectedCategory == 'Tümü') return _institutions;
    return _institutions.where((i) => i.category == _selectedCategory).toList();
  }

  void _showInstitutionDetails(BuildContext context, InstitutionModel institution) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InstitutionDetailsSheet(
        institution: institution,
        onReviewAdded: () {
          _loadMapData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Erişilebilir Kurumlar'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: AppColors.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = category);
                    },
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.background,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(40.352, 27.973),
                    initialZoom: 13,
                    onMapReady: () {
                      _loadMapData();
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.izge.app',
                    ),
                    MarkerLayer(
                      markers: [
                        ..._filteredInstitutions.map((inst) {
                          return Marker(
                            point: inst.location,
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => _showInstitutionDetails(context, inst),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getCategoryIcon(inst.category),
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        }),
                        if (_currentPosition != null)
                          Marker(
                            point: _currentPosition!,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _loadMapData,
                      icon: _isLoading 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.search, size: 20),
                      label: Text(_isLoading ? 'Aranıyor...' : 'Bu Alanda Ara'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.surfaceElevated,
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(_currentPosition!, 14);
          } else {
            _getCurrentLocation();
          }
        },
        child: Icon(Icons.my_location, color: AppColors.accent),
      ),
    );
  }
}

class _InstitutionDetailsSheet extends StatefulWidget {
  final InstitutionModel institution;
  final VoidCallback onReviewAdded;

  const _InstitutionDetailsSheet({required this.institution, required this.onReviewAdded});

  @override
  State<_InstitutionDetailsSheet> createState() => _InstitutionDetailsSheetState();
}

class _InstitutionDetailsSheetState extends State<_InstitutionDetailsSheet> {
  void _showReviewDialog() {
    double rating = 5.0;
    bool isAutismFriendly = false;
    bool hasWheelchairAccess = false;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text('Erişilebilirlik Puanı Ver', style: TextStyle(color: AppColors.textPrimary)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Mekanın erişilebilirliğini değerlendirin:', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Genel Puan', style: TextStyle(color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              ),
                              onPressed: () {
                                setDialogState(() => rating = index + 1.0);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Otizm / Duyusal Dostu', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                      value: isAutismFriendly,
                      activeColor: AppColors.accent,
                      onChanged: (val) => setDialogState(() => isAutismFriendly = val),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('Tekerlekli Sandalye Uygunluğu', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                      value: hasWheelchairAccess,
                      activeColor: AppColors.accent,
                      onChanged: (val) => setDialogState(() => hasWheelchairAccess = val),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      await SupabaseService.instance.submitPlaceReview(
                        osmId: widget.institution.id,
                        rating: rating,
                        isAutismFriendly: isAutismFriendly,
                        hasWheelchairAccess: hasWheelchairAccess,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Puanınız kaydedildi, teşekkürler!')));
                        Navigator.pop(context);
                        widget.onReviewAdded();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Gönder'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget _buildAccessBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final institution = widget.institution;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  institution.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      institution.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                    if (institution.reviewCount > 0)
                      Text(
                        ' (${institution.reviewCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            institution.category,
            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  institution.address,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                institution.phone,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Erişilebilirlik İmkanları'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (institution.accessibility['wheelchair'] == true)
                _buildAccessBadge(Icons.accessible, 'Tekerlekli Sandalye'),
              if (institution.accessibility['elevator'] == true)
                _buildAccessBadge(Icons.elevator, 'Asansör'),
              if (institution.accessibility['parking'] == true)
                _buildAccessBadge(Icons.local_parking, 'Engelli Otoparkı'),
              if (institution.accessibility['autism_friendly'] == true)
                _buildAccessBadge(Icons.hearing_disabled, 'Otizm Dostu'),
              if (institution.accessibility['sign_language'] == true)
                _buildAccessBadge(Icons.sign_language, 'İşaret Dili'),
              if (institution.accessibility.values.every((v) => v == false))
                Text('Bilgi yok', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (institution.phone == 'Telefon bilgisi yok') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 8),
                              Text('Hata', style: TextStyle(color: AppColors.textPrimary)),
                            ],
                          ),
                          content: Text('Bu mekanın telefon numarası sistemde bulunamadı.', style: TextStyle(color: AppColors.textSecondary)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Tamam', style: TextStyle(color: AppColors.accent)),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    final Uri url = Uri.parse('tel:${institution.phone.replaceAll(RegExp(r'\s+'), '')}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: Text('Ara'.tr()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.accent,
                    side: BorderSide(color: AppColors.accent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${institution.location.latitude},${institution.location.longitude}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.directions),
                  label: Text('Yol Tarifi'.tr()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showReviewDialog,
              icon: const Icon(Icons.star_rate),
              label: Text('Erişilebilirlik Puanı Ver'.tr()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.amber,
                side: const BorderSide(color: Colors.amber),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
