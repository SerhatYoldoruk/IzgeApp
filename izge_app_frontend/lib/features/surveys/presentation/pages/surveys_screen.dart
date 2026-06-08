import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/survey_detail_screen.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/survey_results_screen.dart';

import 'package:izge_app_frontend/core/widgets/notification_badge_icon.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_bloc.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_state.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_event.dart';
import 'package:izge_app_frontend/features/navigation/presentation/widgets/custom_drawer.dart';
import 'package:izge_app_frontend/core/models/poll_model.dart';

class SurveysScreen extends StatelessWidget {
  const SurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }
        ),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/images/images/logo.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'İzge App',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          const NotificationBadgeIcon(),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () async {
          context.read<SurveyBloc>().add(SurveyFetchRequested());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktif Anketler'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<SurveyBloc, SurveyState>(
              builder: (context, state) {
                if (state is SurveyLoading) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (state is SurveyError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 48, color: AppColors.textSecondary),
                          const SizedBox(height: 16),
                          Text(
                            LanguageController.instance.isTurkish 
                              ? 'Bağlantı hatası. Lütfen internetinizi kontrol edin.'
                              : 'Connection error. Please check your internet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is SurveyLoaded) {
                  final activeSurveys = state.surveys.where((s) => s.status == 'active').toList();
                  final pastSurveys = state.surveys.where((s) => s.status != 'active').toList();

                  if (state.surveys.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'Henüz oluşturulmuş bir anket yok.'.tr(),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activeSurveys.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'Şu anda aktif anket bulunmuyor.'.tr(),
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ...activeSurveys.map((survey) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _ActiveSurveyCard(
                            title: survey.title.tr(),
                            timeRemaining: survey.endDate != null 
                              ? '${survey.endDate!.difference(DateTime.now()).inDays} ${'Gün Kaldı'.tr()}' 
                              : 'Devam Ediyor'.tr(),
                            description: (survey.description ?? '').tr(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SurveyDetailScreen(survey: survey)),
                              );
                            },
                          ),
                        );
                      }),
                      
                      SizedBox(height: 32),
                      Text(
                        'Geçmiş Anketler'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (pastSurveys.isEmpty)
                        Text(
                          'Geçmiş anket bulunmuyor.'.tr(),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ...pastSurveys.map((survey) {
                        return _PastSurveyCard(
                          title: survey.title.tr(),
                          stats: 'Sonuçlandı'.tr(),
                          survey: survey,
                        );
                      }),
                    ],
                  );
                }
                return const SizedBox();
              }
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _ActiveSurveyCard extends StatelessWidget {
  final String title;
  final String timeRemaining;
  final String description;
  final VoidCallback onTap;

  const _ActiveSurveyCard({
    required this.title,
    required this.timeRemaining,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  timeRemaining,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Ankete Katıl'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastSurveyCard extends StatelessWidget {
  final String title;
  final String stats;
  final PollModel survey;

  const _PastSurveyCard({
    required this.title,
    required this.stats,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SurveyResultsScreen(survey: survey)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        stats,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
