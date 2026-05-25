import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/support_success_screen.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  String? _selectedTopic;

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
          'Teknik Destek',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.contact_support, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Page Title & Intro
            Text(
              'Destek Ekibine Ulaşın',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Sorununuzu daha hızlı çözebilmemiz için lütfen aşağıdaki detayları doldurun.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Form
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Support Topic Dropdown
                Text(
                  'Destek Konusu',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.border, // surface-container-highest
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border), // outline-variant
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTopic,
                      hint: Text('Bir konu seçin', style: TextStyle(color: AppColors.textSecondary)),
                      isExpanded: true,
                      dropdownColor: AppColors.border,
                      icon: Icon(Icons.expand_more, color: AppColors.textSecondary),
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      items: const [
                        DropdownMenuItem(value: 'teknik', child: Text('Teknik Sorun')),
                        DropdownMenuItem(value: 'bagis', child: Text('Bağış İşlemleri')),
                        DropdownMenuItem(value: 'uyelik', child: Text('Üyelik')),
                        DropdownMenuItem(value: 'diger', child: Text('Diğer')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedTopic = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Message Textarea
                Text(
                  'Mesajınız',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.border, // surface-container-highest
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    maxLines: 6,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Sorununuzu buraya detaylıca yazabilirsiniz...',
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Attachment Field
                Text(
                  'Ek (İsteğe Bağlı)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56, // input-height
                    decoration: BoxDecoration(
                      color: AppColors.border, // surface-container-highest
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, style: BorderStyle.none),
                    ),
                    child: Stack(
                      children: [
                        // Dashed border effect using a custom painter or just simple styling
                        // For simplicity, using simple border
                        Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(color: AppColors.border), // should be dashed
                           ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file, color: AppColors.textSecondary),
                            SizedBox(width: 8),
                            Text(
                              'Ekran görüntüsü yükle',
                              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupportSuccessScreen()),
                      );
                    },
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    label: const Text(
                      'Mesajı Gönder',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A8025), // primary-container
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black26,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
