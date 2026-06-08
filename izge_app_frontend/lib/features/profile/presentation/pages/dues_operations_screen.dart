import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/widgets/custom_text_field.dart';

class DuesOperationsScreen extends StatefulWidget {
  const DuesOperationsScreen({super.key});

  @override
  State<DuesOperationsScreen> createState() => _DuesOperationsScreenState();
}

class _DuesOperationsScreenState extends State<DuesOperationsScreen> {
  bool _isLoading = false;

  void _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aidat ödemesi başarıyla tamamlandı!'),
          backgroundColor: Color(0xFF1A8025),
        ),
      );
      Navigator.pop(context);
    }
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
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aidat İşlemleri',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Balance for center title
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 100),
        child: Column(
          children: [
            // Hero Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A8025), // primary-container
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.payments, color: Color(0xFFD3FFC8), size: 40), // on-primary-container
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Üyelik Aidatı',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Derneğimize giriş aidatı 100 TL, sonrasındaki üyelik aidatı aylık 50 TL olarak belirlenmiştir. Katkılarınız derneğimizin gücüne güç katmaktadır.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Bento Grid Information Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                if (isWide) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.calendar_month,
                              'Ödeme Takvimi',
                              [
                                const TextSpan(text: 'Aylık üyelik aidat ödemelerinizi her ayın '),
                                const TextSpan(text: 'son gününe', style: TextStyle(color: Color(0xFF7ADC75), fontWeight: FontWeight.bold)), // primary
                                const TextSpan(text: ' kadar tamamlamanız rica olunur.'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPaymentMethodsCard(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        Icons.receipt_long,
                        'Makbuz Talebi',
                        [
                          const TextSpan(text: 'Havale/EFT ile yapılan ödemelerde açıklama kısmına '),
                          const TextSpan(text: 'TC Kimlik Numaranızı', style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' ve '),
                          const TextSpan(text: 'Ad Soyad', style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' yazmayı unutmayınız. Makbuzunuz e-posta adresinize gönderilecektir.'),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildInfoCard(
                        Icons.calendar_month,
                        'Ödeme Takvimi',
                        [
                          const TextSpan(text: 'Aylık üyelik aidat ödemelerinizi her ayın '),
                          const TextSpan(text: 'son gününe', style: TextStyle(color: Color(0xFF7ADC75), fontWeight: FontWeight.bold)), // primary
                          const TextSpan(text: ' kadar tamamlamanız rica olunur.'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethodsCard(),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        Icons.receipt_long,
                        'Makbuz Talebi',
                        [
                          const TextSpan(text: 'Havale/EFT ile yapılan ödemelerde açıklama kısmına '),
                          const TextSpan(text: 'TC Kimlik Numaranızı', style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' ve '),
                          const TextSpan(text: 'Ad Soyad', style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' yazmayı unutmayınız. Makbuzunuz e-posta adresinize gönderilecektir.'),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            
            SizedBox(height: 32),
            
            // Payment Details Form
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ödeme Bilgileri',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ADC75).withOpacity(0.1),
                    border: Border.all(color: const Color(0xFF7ADC75).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lock, color: Color(0xFF7ADC75), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'SSL Güvenli',
                        style: TextStyle(color: Color(0xFF7ADC75), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentFieldLabel('Kart Üzerindeki İsim'),
                  const CustomTextField(hintText: 'Ad Soyad'),
                  SizedBox(height: 16),
                  
                  _buildPaymentFieldLabel('Kart Numarası'),
                  const CustomTextField(hintText: '0000 0000 0000 0000', prefixIcon: Icons.credit_card),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPaymentFieldLabel('Son Kullanma'),
                            const CustomTextField(hintText: 'AA/YY'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPaymentFieldLabel('CVV'),
                            const CustomTextField(hintText: '***', obscureText: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface, // surface-container
            border: Border(
              top: BorderSide(color: AppColors.border), // surface-variant
            ),
          ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _processPayment,
            icon: _isLoading 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD3FFC8))
                  )
                : const Icon(Icons.payment, color: Color(0xFFD3FFC8)), // on-primary-container
            label: Text(
              _isLoading ? 'İşleniyor...' : 'Aidat Öde',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD3FFC8), // on-primary-container
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A8025), // primary-container
              disabledBackgroundColor: const Color(0xFF1A8025).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, List<TextSpan> spans) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-high
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)), // surface-variant
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.border, // surface-container-highest
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF7ADC75)), // primary
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: spans,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-high
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)), // surface-variant
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.border, // surface-container-highest
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.credit_card, color: Color(0xFF7ADC75)), // primary
              ),
              SizedBox(width: 16),
              Text(
                'Ödeme Yöntemleri',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodItem('Kredi Kartı', 'Uygulama üzerinden güvenle ödeyebilirsiniz.'),
          const SizedBox(height: 12),
          _buildPaymentMethodItem('Banka Havalesi', 'Dernek hesaplarına doğrudan transfer.'),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Color(0xFF7ADC75), size: 20), // primary
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(text: '$title: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary, // on-surface-variant
        ),
      ),
    );
  }
}
