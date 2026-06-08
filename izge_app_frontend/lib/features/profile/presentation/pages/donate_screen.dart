import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_success_screen.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isMonthly = false;
  String _selectedCategory = 'genel';
  int? _selectedAmount = 100;
  final TextEditingController _customAmountController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'genel', 'title': 'Genel Bağış', 'icon': Icons.volunteer_activism},
    {'id': 'tekerlekli', 'title': 'Tekerlekli Sandalye', 'icon': Icons.accessible},
    {'id': 'egitim', 'title': 'Eğitim Desteği', 'icon': Icons.school},
    {'id': 'gida', 'title': 'Gıda Paketi', 'icon': Icons.restaurant},
  ];

  final List<int> _oneTimeAmounts = [50, 100, 250, 500];
  final List<int> _monthlyAmounts = [100, 250, 500, 1000];

  void _toggleDonationType(bool isMonthly) {
    if (_isMonthly == isMonthly) return;
    setState(() {
      _isMonthly = isMonthly;
      _selectedAmount = isMonthly ? _monthlyAmounts[1] : _oneTimeAmounts[1];
      _customAmountController.clear();
    });
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface, // surface-container
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bağış Yap',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Segmented Control (One-time vs Monthly)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // surface-container-highest
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleDonationType(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isMonthly ? AppColors.border : Colors.transparent, // surface-variant
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !_isMonthly
                              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Tek Seferlik',
                          style: TextStyle(
                            color: !_isMonthly ? AppColors.textPrimary : AppColors.textSecondary, // on-surface-variant
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleDonationType(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isMonthly ? AppColors.border : Colors.transparent, // surface-variant
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isMonthly
                              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Aylık Düzenli',
                          style: TextStyle(
                            color: _isMonthly ? AppColors.textPrimary : AppColors.textSecondary, // on-surface-variant
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Category Selection
            Text(
              'Nereye Destek Olmak İstersiniz?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['id']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1A8025).withOpacity(0.1) : AppColors.surfaceElevated, // primary-container/10 or surface-container-low
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF7ADC75) : AppColors.border, // primary or surface-container-highest
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat['icon'],
                          color: const Color(0xFF7ADC75), // primary
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          cat['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),

            // Amount Selection
            Text(
              'Bağış Miktarı',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (_isMonthly ? _monthlyAmounts : _oneTimeAmounts).map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAmount = amount;
                        _customAmountController.clear();
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 56,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1A8025) : AppColors.surfaceElevated, // primary-container vs surface-container-low
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF7ADC75) : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF1A8025).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '₺$amount',
                        style: TextStyle(
                          color: isSelected ? Color(0xFFD3FFC8) : AppColors.textPrimary, // on-primary-container vs on-surface
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() => _selectedAmount = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Diğer Miktar',
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('₺', style: TextStyle(color: AppColors.textSecondary, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 32),
            Divider(color: AppColors.border, thickness: 1),
            SizedBox(height: 32),

            // Payment Details
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentFieldLabel('Kart Üzerindeki İsim'),
                    _buildPaymentTextField(
                      'Ad Soyad',
                      validator: (val) => val == null || val.trim().isEmpty ? 'Gerekli' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildPaymentFieldLabel('Kart Numarası'),
                    _buildPaymentTextField(
                      '0000 0000 0000 0000', 
                      icon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CardNumberFormatter()],
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Gerekli';
                        if (val.length < 19) return 'Geçersiz kart numarası';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentFieldLabel('Son Kullanma'),
                              _buildPaymentTextField(
                                'AA/YY', 
                                isCenter: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [ExpiryDateFormatter()],
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Gerekli';
                                  if (val.length < 5) return 'Geçersiz';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentFieldLabel('CVV'),
                              _buildPaymentTextField(
                                '***', 
                                isCenter: true, 
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Gerekli';
                                  if (val.length < 3) return 'Geçersiz';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DonationSuccessScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen geçerli ödeme bilgileri girin')),
                    );
                  }
                },
                icon: Icon(Icons.favorite, color: Color(0xFF003908)),
                label: Text(
                  _isMonthly ? 'Aylık Bağışı Başlat' : 'Bağışı Tamamla',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003908),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A8025), // primary-container
                  foregroundColor: const Color(0xFFD3FFC8), // on-primary-container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF1A8025).withOpacity(0.3),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_isMonthly)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Aylık düzenli bağışlarınız, her ayın aynı gününde kartınızdan otomatik olarak çekilecektir. İstediğiniz zaman iptal edebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7ADC75), // primary color text to make it stand out
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ),
            if (_isMonthly) const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Yukarıdaki butona tıklayarak Aydınlatma Metni\'ni okuduğunuzu ve kabul ettiğinizi onaylamış olursunuz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary, // on-surface-variant
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildPaymentTextField(String hint, {IconData? icon, bool isCenter = false, bool obscureText = false, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator}) {
    return TextFormField(
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, letterSpacing: 1.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), letterSpacing: 0),
        filled: true,
        fillColor: AppColors.border,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: icon != null ? 18 : 16),
        suffixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    
    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      formattedText += newText[i];
      if ((i + 1) % 4 == 0 && i != newText.length - 1) {
        formattedText += ' ';
      }
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    
    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      formattedText += newText[i];
      if (i == 1 && newText.length > 2) {
        formattedText += '/';
      }
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
