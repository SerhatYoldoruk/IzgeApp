import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/request_detail_screen.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Talep Durumu Sorgulama',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Intro
            Text(
              'Daha önce oluşturduğunuz bir talebin güncel durumunu öğrenmek için talep numaranızı aşağıya giriniz.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            
            // Search Form
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceElevated, // surface-container-high
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                hintText: 'Talep Numarası (Örn: TLP-12345)',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_searchController.text.trim().isEmpty) return;
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  
                  setState(() {
                    _isLoading = true;
                  });
                  
                  final req = await SupabaseService.instance.getRequestByShortId(_searchController.text.trim());
                  
                  if (!mounted) return;
                  setState(() {
                    _isLoading = false;
                  });
                  
                  if (req != null) {
                    navigator.push(
                      MaterialPageRoute(builder: (context) => RequestDetailScreen(request: req)),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Talep bulunamadı. Lütfen numaranızı kontrol edin.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                icon: _isLoading 
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF003908), strokeWidth: 2))
                    : const SizedBox.shrink(),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLoading ? 'Sorgulanıyor...' : 'Sorgula',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003908), // on-primary
                      ),
                    ),
                    if (!_isLoading) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Color(0xFF003908), size: 16),
                    ],
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A8025), // primary-container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info, color: Color(0xFF7ADC75)), // primary
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Talep Numaramı Nereden Bulabilirim?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Talebinizi oluşturduğunuzda size gönderilen onay e-postasında veya SMS mesajında 'TLP-' ile başlayan numaranızı bulabilirsiniz.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Remove the hardcoded dummy result card
          ],
        ),
      ),
    );
  }
}
