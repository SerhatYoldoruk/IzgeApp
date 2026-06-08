import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class ActiveDevicesScreen extends StatefulWidget {
  const ActiveDevicesScreen({super.key});

  @override
  State<ActiveDevicesScreen> createState() => _ActiveDevicesScreenState();
}

class _ActiveDevicesScreenState extends State<ActiveDevicesScreen> {
  late List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDeviceName();
  }

  Future<void> _loadDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String name = 'Bilinmeyen Cihaz';
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        String manufacturer = info.manufacturer;
        if (manufacturer.isNotEmpty) manufacturer = manufacturer[0].toUpperCase() + manufacturer.substring(1);
        name = '$manufacturer ${info.model}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        name = info.name;
      } else if (Platform.isWindows) {
        name = 'Windows PC';
      } else if (Platform.isMacOS) {
        name = 'Mac';
      }
    } catch (e) {
      name = 'Bilinmeyen Cihaz';
    }

    if (mounted) {
      setState(() {
        _devices = [
          {
            'name': name,
            'icon': _getDeviceIcon(),
            'location': 'Türkiye',
            'status': 'Şu an aktif',
            'isCurrent': true,
          }
        ];
      });
    }
  }

  IconData _getDeviceIcon() {
    if (Platform.isAndroid || Platform.isIOS) return Icons.smartphone;
    if (Platform.isMacOS) return Icons.laptop_mac;
    return Icons.computer;
  }

  void _logoutDevice(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Oturumu Kapat',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${_devices[index]['name']} cihazındaki oturumu kapatmak istediğinize emin misiniz?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _devices.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Oturum başarıyla kapatıldı!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1A8025),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(24),
                ),
              );
            },
            child: const Text('Kapat', style: TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aktif Cihazlar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hesabınıza erişimi olan tüm cihazlar burada listelenir.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            ...List.generate(_devices.length, (index) {
              final device = _devices[index];
              final bool isCurrent = device['isCurrent'] as bool;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.surfaceElevated // surface-container-high
                        : AppColors.surface, // surface-container
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCurrent
                          ? AppColors.border.withOpacity(0.3)
                          : AppColors.border.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF1A8025).withOpacity(0.2) // primary-container/20
                              : AppColors.border, // surface-variant
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          device['icon'] as IconData,
                          color: isCurrent
                              ? const Color(0xFF7ADC75) // primary
                              : AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device['name'] as String,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${device['location']} • ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (isCurrent)
                                  const Text(
                                    'Şu an aktif',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7ADC75), // primary
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: Text(
                                      device['status'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!isCurrent)
                        IconButton(
                          onPressed: () => _logoutDevice(index),
                          icon: const Icon(Icons.logout, color: Color(0xFFFFB4AB)), // error
                          tooltip: 'Oturumu Kapat',
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
