import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:confetti/confetti.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  final List<Map<String, dynamic>> _routines = [
    {'title': 'Diş Fırçalama', 'icon': Icons.clean_hands, 'isCompleted': false, 'color': Colors.lightBlue},
    {'title': 'Giyinme', 'icon': Icons.checkroom, 'isCompleted': false, 'color': Colors.orange},
    {'title': 'Kahvaltı Yapma', 'icon': Icons.breakfast_dining, 'isCompleted': false, 'color': Colors.green},
    {'title': 'Çantayı Hazırlama', 'icon': Icons.backpack, 'isCompleted': false, 'color': Colors.purple},
  ];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleRoutine(int index) {
    setState(() {
      _routines[index]['isCompleted'] = !_routines[index]['isCompleted'];
    });

    // Check if all completed
    if (_routines.every((routine) => routine['isCompleted'] == true)) {
      _confettiController.play();
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 32),
            const SizedBox(width: 8),
            Text('Harikasın!'.tr(), style: TextStyle(color: AppColors.accent)),
          ],
        ),
        content: Text(
          'Sabah rutinindeki tüm görevleri başarıyla tamamladın!'.tr(),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tamam'.tr(), style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _resetRoutines() {
    setState(() {
      for (var routine in _routines) {
        routine['isCompleted'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Günlük Rutin Takibi'.tr(),
          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetRoutines,
            tooltip: 'Sıfırla'.tr(),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _routines.length + 1, // +1 for header
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sabah Rutini'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Güne başlarken yapmamız gerekenler:'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final routine = _routines[index - 1];
              final isCompleted = routine['isCompleted'];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isCompleted ? routine['color'].withOpacity(0.1) : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted ? routine['color'] : AppColors.border,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCompleted ? routine['color'] : AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      routine['icon'],
                      color: isCompleted ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  title: Text(
                    routine['title'].toString().tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? routine['color'] : AppColors.textPrimary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () => _toggleRoutine(index - 1),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? routine['color'] : Colors.transparent,
                        border: Border.all(
                          color: isCompleted ? routine['color'] : AppColors.textSecondary,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 24)
                          : null,
                    ),
                  ),
                  onTap: () => _toggleRoutine(index - 1),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // down
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
