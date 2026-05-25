import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/event_success_screen.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Yeni Etkinlik Talebi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDg8kVQI8tZohfef8LCkAxtR1FB9RYrs5Me8hil5cAIKPYnQ_7oOXFMTxgjmYO0EmMEJYZycP22pFQX3sOw4tCDvVsLfeFgbxSl3G1Gb3wBVT66PE_v2p9t9k1h19OZnJDZ-LQqotuiuR-MXY_AKvReJovBqpb7bYJ8r-TfLmMCnUgL9UDtrl_lY9Hr333tIcraqq8xDQxyAjiz0oN-hyCVNVNnHZhsEC5517haHt7F4aDEqkAYX7YEopYqzbLiAfgTvLa8bA0YEEkb',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.business, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etkinlik Adı
            Text(
              'Etkinlik Adı',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            _buildTextField('Örn: Yıllık Geleneksel Orman Kampı'),
            const SizedBox(height: 16),

            // Etkinlik Türü
            Text(
              'Etkinlik Türü',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Tür seçiniz', style: TextStyle(color: AppColors.textSecondary)),
                  dropdownColor: AppColors.surface,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  items: const [
                    DropdownMenuItem(value: 'seminar', child: Text('Seminer')),
                    DropdownMenuItem(value: 'workshop', child: Text('Atölye')),
                    DropdownMenuItem(value: 'planting', child: Text('Fidan Dikimi')),
                    DropdownMenuItem(value: 'festival', child: Text('Festival')),
                    DropdownMenuItem(value: 'other', child: Text('Diğer')),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ),
            SizedBox(height: 16),

            // Tarih ve Saat
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarih',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 8),
                      _buildTextField('gg.aa.yyyy', icon: Icons.calendar_today),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saat',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 8),
                      _buildTextField('--:--', icon: Icons.access_time),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lokasyon / Yer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lokasyon / Yer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    Text(
                      'Online Etkinlik',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isOnline,
                      onChanged: (val) {
                        setState(() {
                          _isOnline = val;
                        });
                      },
                      activeColor: AppColors.accent,
                      inactiveThumbColor: AppColors.textSecondary,
                      inactiveTrackColor: AppColors.surfaceElevated,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildTextField(
              _isOnline ? 'Online toplantı linkini giriniz (Zoom, Meet vb.)' : 'Açık adres veya link giriniz',
            ),
            const SizedBox(height: 16),

            // Açıklama
            Text(
              'Açıklama',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                maxLines: 4,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Etkinliğin amacı, hedef kitlesi ve beklentilerinizi detaylandırın...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Ek Dosya / Görsel Upload
            Text(
              'Ek Dosya / Görsel',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 2), // Dashed border replacement
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, color: AppColors.accent, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Görsel veya PDF yüklemek için dokunun',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Maksimum dosya boyutu: 5MB',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EventSuccessScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A8025), // primary-container
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: const Color(0xFF1A8025).withOpacity(0.5),
              ),
              icon: const Icon(Icons.send),
              label: const Text(
                'Talep Gönder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 32), // Padding for bottom navbar
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
        ),
      ),
    );
  }
}
