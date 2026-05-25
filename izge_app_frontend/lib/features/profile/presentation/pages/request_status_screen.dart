import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/request_detail_screen.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  bool _isLoading = false;
  bool _showResult = true; // Show mock result by default for demo purposes

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
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      _isLoading = false;
                      _showResult = true;
                    });
                  });
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
            
            if (_showResult) ...[
              SizedBox(height: 32),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border.withOpacity(0.5))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ÖRNEK SONUÇ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF899484), // outline
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border.withOpacity(0.5))),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Mock Result Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RequestDetailScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated, // surface-container-high
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.border, // surface-variant
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'TLP-84729',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tekerlekli Sandalye Bakımı',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Oluşturulma: 12 Ekim 2023',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated, // secondary-container
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pending, color: Color(0xFFB4B5B5), size: 16), // on-secondary-container
                              SizedBox(width: 4),
                              Text(
                                'İşlemde',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB4B5B5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Progress Stepper (Simplified for Flutter)
                    Row(
                      children: [
                        _buildStep(Icons.check, 'Alındı', true, true),
                        Expanded(child: _buildLine(true)),
                        _buildStep(Icons.circle, 'Değerlendirmede', true, false),
                        Expanded(child: _buildLine(false)),
                        _buildStep(null, 'Onay', false, false),
                        Expanded(child: _buildLine(false)),
                        _buildStep(null, 'Tamamlandı', false, false),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.5), // surface-container
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border.withOpacity(0.3)),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          children: [
                            TextSpan(
                              text: 'Güncelleme: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Talebiniz ilgili uzman ekibimize iletilmiştir. İnceleme süreci devam etmektedir.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(IconData? icon, String label, bool isActive, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive 
                ? (isCompleted ? const Color(0xFF7ADC75) : const Color(0xFF1A8025)) 
                : AppColors.border,
            shape: BoxShape.circle,
            border: isActive && !isCompleted 
                ? Border.all(color: AppColors.background, width: 3) 
                : (!isActive ? Border.all(color: AppColors.surfaceElevated, width: 2) : null),
            boxShadow: isActive && !isCompleted ? [
              BoxShadow(
                color: const Color(0xFF7ADC75).withOpacity(0.4),
                blurRadius: 8,
              )
            ] : null,
          ),
          child: isCompleted && icon != null
              ? Icon(icon, color: const Color(0xFF002203), size: 14)
              : (!isCompleted && isActive && icon != null ? Icon(icon, color: const Color(0xFF7ADC75), size: 10) : null),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? (isCompleted ? AppColors.textPrimary : Color(0xFF7ADC75)) : AppColors.textSecondary.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      height: 4,
      color: isActive ? const Color(0xFF7ADC75) : AppColors.border,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}
