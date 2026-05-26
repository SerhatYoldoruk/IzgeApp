import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class ActiveDevicesScreen extends StatefulWidget {
  const ActiveDevicesScreen({super.key});

  @override
  State<ActiveDevicesScreen> createState() => _ActiveDevicesScreenState();
}

class _ActiveDevicesScreenState extends State<ActiveDevicesScreen> {
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'iPhone 14 Pro',
      'icon': Icons.smartphone,
      'location': 'İstanbul, TR',
      'status': 'Şu an aktif',
      'isCurrent': true,
    },
    {
      'name': 'MacBook Pro M2',
      'icon': Icons.laptop_mac,
      'location': 'Ankara, TR',
      'status': 'Son görülme: Dün, 14:30',
      'isCurrent': false,
    },
    {
      'name': 'Windows PC',
      'icon': Icons.computer,
      'location': 'İzmir, TR',
      'status': 'Son görülme: 3 gün önce',
      'isCurrent': false,
    },
  ];

  void _logoutDevice(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Oturumu Kapat'.tr(),
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${_devices[index]['name']} ${'cihazındaki oturumu kapatmak istediğinize emin misiniz?'.tr()}',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'.tr(), style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _devices.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Oturum başarıyla kapatıldı!'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1A8025),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(24),
                ),
              );
            },
            child: Text('Kapat'.tr(), style: const TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
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
        title: Text(
          'Aktif Cihazlar'.tr(),
          style: const TextStyle(
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
              'Hesabınıza erişimi olan tüm cihazlar burada listelenir.'.tr(),
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
                                  '${(device['location'] as String).tr()} • ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (isCurrent)
                                  Text(
                                    'Şu an aktif'.tr(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7ADC75), // primary
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: Text(
                                      (device['status'] as String).tr(),
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
                          tooltip: 'Oturumu Kapat'.tr(),
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
