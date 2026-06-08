import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

import 'package:izge_app_frontend/core/models/poll_model.dart';
import 'package:izge_app_frontend/core/services/tts_service.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';

class SurveyDetailScreen extends StatefulWidget {
  final PollModel survey;
  const SurveyDetailScreen({super.key, required this.survey});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  String? _selectedOption;
  bool _isSubmitting = false;
  bool _isSuccess = false;
  bool _hasSubmittedBefore = false;
  int _participantCount = 0;

  @override
  void initState() {
    super.initState();
    _checkSubmissionStatus();
  }

  @override
  void dispose() {
    if (_isReading) {
      TTSService.instance.stop();
    }
    super.dispose();
  }

  bool _isReading = false;

  void _toggleReading() async {
    if (_isReading) {
      await TTSService.instance.stop();
      if (mounted) setState(() => _isReading = false);
    } else {
      if (mounted) setState(() => _isReading = true);
      final textToRead = "${widget.survey.title}. ${widget.survey.description}. Hangi alanda atölye açılmasını istersiniz?. Seçenekler: ${widget.survey.options.join(', ')}";
      await TTSService.instance.speak(textToRead);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isReading = TTSService.instance.isSpeaking;
          });
        }
      });
    }
  }

  Future<void> _checkSubmissionStatus() async {
    try {
      final results = await SupabaseService.instance.getPollResults(widget.survey.id);
      if (mounted) {
        setState(() {
          _participantCount = results.length;
        });
      }

      final userVoteText = await SupabaseService.instance.getUserVote(widget.survey.id);
      if (userVoteText != null && mounted) {
        setState(() {
          _hasSubmittedBefore = true;
          _isSuccess = true;
          _selectedOption = userVoteText;
        });
      }
    } catch (e) {
      debugPrint("Error checking submission: $e");
    }
  }

  void _submit() async {
    if (_selectedOption == null || _isSubmitting || _isSuccess || _hasSubmittedBefore) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await SupabaseService.instance.vote(
        pollId: widget.survey.id,
        optionText: _selectedOption!,
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
          _hasSubmittedBefore = true;
          _participantCount++;
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Yanıtınız başarıyla kaydedildi.'.tr()),
                backgroundColor: AppColors.accent,
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu. Tekrar deneyin.'.tr()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'İzge App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.textSecondary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(_isReading ? Icons.stop : Icons.volume_up, color: AppColors.textSecondary),
            onPressed: _toggleReading,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ambient Glow (Decorative)
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poll Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated, // surface-container-high
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
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
                                color: AppColors.accent.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.poll, color: AppColors.accent, size: 20),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'TOPLULUK GELİŞİMİ'.tr(),
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.survey.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.survey.description ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24),
                        Divider(color: AppColors.border),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.group, color: AppColors.textSecondary, size: 18),
                            SizedBox(width: 8),
                            Text('$_participantCount ${'Katılım'.tr()}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 24),
                            Icon(Icons.schedule, color: AppColors.textSecondary, size: 18),
                            SizedBox(width: 8),
                            Text(widget.survey.endDate != null ? '${widget.survey.endDate!.difference(DateTime.now()).inDays} ${'Gün Kaldı'.tr()}' : 'Devam Ediyor'.tr(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Question
                  Text(
                    'Lütfen bir seçenek belirleyin.'.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Yalnızca bir seçenek işaretleyebilirsiniz.'.tr(),
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 16),
                  // Options
                  ...widget.survey.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildOption(
                        value: option,
                        title: option,
                        subtitle: '',
                        icon: Icons.label_outline,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Sticky Bottom Action Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.95),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: _selectedOption == null ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSuccess 
                      ? AppColors.surfaceElevated // surface-bright
                      : const Color(0xFF1A8025), // primary-container
                  disabledBackgroundColor: const Color(0xFF1A8025).withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: _selectedOption == null ? 0 : 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSubmitting) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFD3FFC8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Kaydediliyor...'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD3FFC8),
                        ),
                      ),
                    ] else if (_isSuccess) ...[
                      Icon(Icons.check_circle, color: AppColors.accent),
                      SizedBox(width: 12),
                      Text(
                        'Yanıtınız Alındı'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Yanıtı Gönder'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedOption == null 
                              ? const Color(0xFFD3FFC8).withValues(alpha: 0.5) 
                              : const Color(0xFFD3FFC8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.send,
                        color: _selectedOption == null 
                              ? const Color(0xFFD3FFC8).withValues(alpha: 0.5) 
                              : const Color(0xFFD3FFC8),
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = _selectedOption == value;
    
    return GestureDetector(
      onTap: () {
        if (!_isSubmitting && !_isSuccess) {
          setState(() {
            _selectedOption = value;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A8025).withValues(alpha: 0.1) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Custom Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accent : Color(0xFF899484), // outline
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.accent : Color(0xFF899484).withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
