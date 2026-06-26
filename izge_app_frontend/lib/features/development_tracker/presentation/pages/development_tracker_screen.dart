import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/development_tracker/presentation/bloc/development_bloc.dart';
import 'package:izge_app_frontend/features/development_tracker/presentation/bloc/development_state.dart';
import 'package:izge_app_frontend/features/development_tracker/data/models/development_assessment_model.dart';
import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'development_assessment_screen.dart';

class DevelopmentTrackerScreen extends StatefulWidget {
  const DevelopmentTrackerScreen({super.key});

  @override
  State<DevelopmentTrackerScreen> createState() => _DevelopmentTrackerScreenState();
}

class _DevelopmentTrackerScreenState extends State<DevelopmentTrackerScreen> {

  Widget _buildProgressCard(String title, String key, IconData icon, Color color, List<DevelopmentAssessment> assessments) {
    // Ilgili kategoriye ait testleri bul
    final areaAssessments = assessments.where((a) => a.area == key).toList();
    
    double score = 0;
    String date = '-';

    if (areaAssessments.isNotEmpty) {
      final latest = areaAssessments.last; // En son eklenen sona gelir
      score = latest.score;
      date = '${latest.createdAt.day}.${latest.createdAt.month}.${latest.createdAt.year}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Spacer küçültüldü
          SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  backgroundColor: AppColors.background,
                  color: color,
                  strokeWidth: 8,
                ),
                Center(
                  child: Text(
                    '${score.toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'Son Güncelleme:'.tr(),
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevelopmentBloc, DevelopmentState>(
      builder: (context, state) {
        bool isLoading = state is DevelopmentLoading;
        List<DevelopmentAssessment> assessments = [];
        if (state is DevelopmentLoaded) {
          assessments = state.assessments;
        }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Gelişim Takibi'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF Raporu hazırlanıyor...'.tr())),
              );
            },
            tooltip: 'Rapor Oluştur'.tr(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Çocuğun bilgisi (Dummy)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent.withOpacity(0.8), AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: const Icon(Icons.child_care, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deniz Yılmaz',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4 Yaş, 2 Ay · Otizm Spektrum'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Gelişim Alanları'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75, // Düzeltme: Overflow olmaması için 0.85'ten 0.75'e çekildi
              children: [
                _buildProgressCard('Motor Gelişim'.tr(), 'motor', Icons.directions_run, Colors.blue, assessments),
                _buildProgressCard('Bilişsel Gelişim'.tr(), 'cognitive', Icons.psychology, Colors.orange, assessments),
                _buildProgressCard('Dil ve İletişim'.tr(), 'language', Icons.record_voice_over, Colors.green, assessments),
                _buildProgressCard('Sosyal/Duygusal'.tr(), 'social', Icons.favorite, Colors.red, assessments),
              ],
            ),
            const SizedBox(height: 32),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
            // İlerleme Grafiği (Son 6 ay dummy data)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Genel İlerleme'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Son 6 Ay',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const titles = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz'];
                                if (value >= 0 && value < titles.length) {
                                  return Text(titles[value.toInt()], style: TextStyle(color: AppColors.textSecondary, fontSize: 10));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 40),
                              FlSpot(1, 45),
                              FlSpot(2, 42),
                              FlSpot(3, 50),
                              FlSpot(4, 58),
                              FlSpot(5, 65),
                            ],
                            isCurved: true,
                            color: AppColors.accent,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.accent.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Buton için boşluk
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DevelopmentAssessmentScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            'Yeni Değerlendirme Yap'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
      },
    );
  }
}
