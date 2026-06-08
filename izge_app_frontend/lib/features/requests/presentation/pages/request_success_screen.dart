import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/models/request_model.dart';

class RequestSuccessScreen extends StatelessWidget {
  final RequestModel request;
  const RequestSuccessScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: const Color(0xFF1A8025).withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A8025).withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Color(0xFF7ADC75),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Talebiniz Başarıyla Alındı'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text(
                      'Talep Numaranız:',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 4),
                    Builder(builder: (context) {
                      final idStr = request.id;
                      final shortCode = 'TLP-${idStr.substring(0, idStr.length < 8 ? idStr.length : 8).toUpperCase()}';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            shortCode,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7ADC75),
                              letterSpacing: 2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: AppColors.textSecondary, size: 20),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: shortCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Talep numarası kopyalandı')),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Talebiniz uzman ekiplerimize iletilmiştir. Bu numara ile talebinizin durumunu Taleplerim sayfasından takip edebilirsiniz.'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A8025),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF1A8025).withOpacity(0.4),
                  ),
                  child: Text(
                    'Taleplerime Dön'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
