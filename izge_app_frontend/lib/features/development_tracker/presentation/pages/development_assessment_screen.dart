import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/development_tracker/presentation/bloc/development_bloc.dart';
import 'package:izge_app_frontend/features/development_tracker/presentation/bloc/development_event.dart';

class DevelopmentAssessmentScreen extends StatefulWidget {
  const DevelopmentAssessmentScreen({super.key});

  @override
  State<DevelopmentAssessmentScreen> createState() => _DevelopmentAssessmentScreenState();
}

class _DevelopmentAssessmentScreenState extends State<DevelopmentAssessmentScreen> {
  int _currentStep = 0;
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _areas = [
    {
      'id': 'motor',
      'title': 'Motor Gelişim',
      'icon': Icons.directions_run,
      'color': Colors.blue,
      'questions': [
        {'id': 'm1', 'text': 'Desteksiz oturabiliyor mu?', 'type': 'slider', 'value': 3.0},
        {'id': 'm2', 'text': 'Merdivenleri yardımsız inip çıkabiliyor mu?', 'type': 'toggle', 'value': 'Bazen'},
        {'id': 'm3', 'text': 'Kalem/boya fırçası tutabiliyor mu?', 'type': 'slider', 'value': 4.0},
      ]
    },
    {
      'id': 'cognitive',
      'title': 'Bilişsel Gelişim',
      'icon': Icons.psychology,
      'color': Colors.orange,
      'questions': [
        {'id': 'c1', 'text': 'İsmi söylendiğinde tepki veriyor mu?', 'type': 'slider', 'value': 5.0},
        {'id': 'c2', 'text': 'Basit talimatları (Örn: "Topu getir") yerine getiriyor mu?', 'type': 'toggle', 'value': 'Evet'},
        {'id': 'c3', 'text': 'Nesneleri renk veya şekline göre gruplayabiliyor mu?', 'type': 'slider', 'value': 2.0},
      ]
    },
  ];

  Widget _buildSliderQuestion(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['text'],
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('Hiç', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Expanded(
              child: Slider(
                value: question['value'],
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColors.accent,
                inactiveColor: AppColors.accent.withOpacity(0.2),
                label: question['value'].toInt().toString(),
                onChanged: (val) {
                  setState(() => question['value'] = val);
                },
              ),
            ),
            Text('Sürekli', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleQuestion(Map<String, dynamic> question) {
    final options = ['Hayır', 'Bazen', 'Evet'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['text'],
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((opt) {
            final isSelected = question['value'] == opt;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Center(child: Text(opt)),
                  selected: isSelected,
                  selectedColor: AppColors.accent,
                  backgroundColor: AppColors.surfaceElevated,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => question['value'] = opt);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final area = _areas[_currentStep];
    final isLastStep = _currentStep == _areas.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Değerlendirme Formu'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Step indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              children: List.generate(_areas.length, (index) {
                final isActive = index <= _currentStep;
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.accent : AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Area Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: area['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(area['icon'], color: area['color'], size: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        area['title'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Questions
                  ...(area['questions'] as List).map((q) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: q['type'] == 'slider' 
                            ? _buildSliderQuestion(q) 
                            : _buildToggleQuestion(q),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  
                  // Notes (Only on last step)
                  if (isLastStep) ...[
                    Text(
                      'Terapist İçin Notlar (Opsiyonel)'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Bu ayki gözlemlerinizi yazabilirsiniz...'.tr(),
                        filled: true,
                        fillColor: AppColors.surfaceElevated,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.accent),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (isLastStep) {
              // Calculate score and save for EACH area
              final bloc = context.read<DevelopmentBloc>();
              for (var area in _areas) {
                double score = 0; 
                final questions = area['questions'] as List;
                if (questions.isNotEmpty) {
                    for (var q in questions) {
                        if (q['type'] == 'slider') {
                            score += (q['value'] / 5.0) * 100;
                        } else {
                            if (q['value'] == 'Evet') {
                              score += 100;
                            // ignore: curly_braces_in_flow_control_structures
                            } else if (q['value'] == 'Bazen') score += 50;
                        }
                    }
                    score = score / questions.length;
                }
                
                bloc.add(AddAssessment(
                  area: area['id'],
                  score: score,
                  answers: {'questions': questions},
                  notes: _notesController.text,
                ));
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tüm değerlendirmeler başarıyla kaydedildi!'.tr())),
              );
              Navigator.pop(context);
            } else {
              setState(() => _currentStep++);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            isLastStep ? 'Tamamla ve Kaydet'.tr() : 'Sonraki Adım'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
