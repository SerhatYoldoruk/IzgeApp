import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/models/request_model.dart';
import 'package:izge_app_frontend/features/support/presentation/pages/live_support_screen.dart';
import 'package:intl/intl.dart';

class RequestDetailScreen extends StatelessWidget {
  final RequestModel request;
  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // Status bilgileri
    final statusInfo = _getStatusInfo(request.status);
    final formattedDate = DateFormat('d MMM yyyy, HH:mm', 'tr_TR').format(request.createdAt);
    final idStr = request.id;
    final shortId = 'TLP-${idStr.substring(0, idStr.length < 8 ? idStr.length : 8).toUpperCase()}';

    // Kategori label
    final categoryLabel = _getCategoryLabel(request.requestType);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Talep Detayı',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Başlık + Durum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: statusInfo.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: statusInfo.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusInfo.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusInfo.label,
                        style: TextStyle(
                          color: statusInfo.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bilgi Kartı
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori + Tarih + ID
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          shortId,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tarih
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.border),
                  ),
                  // Talep Mesajı
                  Text(
                    'TALEP MESAJI',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    request.description,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Süreç Takibi
            Text(
              'Süreç Takibi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _buildTimelineSteps(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
            );
          },
          icon: const Icon(Icons.support_agent, color: Colors.white),
          label: const Text(
            'Canlı Desteğe Bağlan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A8025),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: const Color(0xFF1A8025).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimelineSteps() {
    final steps = <_TimelineStepData>[];
    final formattedDate = DateFormat('d MMM yyyy, HH:mm', 'tr_TR').format(request.createdAt);

    // Adım 1 — Talep Alındı (her zaman tamamlanmış)
    steps.add(_TimelineStepData(
      title: 'Talep Alındı',
      time: formattedDate,
      isCompleted: true,
    ));

    // Adım 2 — İnceleniyor
    if (request.status == 'pending') {
      steps.add(_TimelineStepData(
        title: 'İnceleniyor',
        time: 'Ekibimiz talebinizi inceliyor',
        isCompleted: false,
        isCurrent: true,
      ));
    } else {
      steps.add(_TimelineStepData(
        title: 'İncelendi',
        time: 'Talep incelendi',
        isCompleted: true,
      ));
    }

    // Adım 3 — Durum
    if (request.status == 'approved') {
      steps.add(_TimelineStepData(
        title: 'Onaylandı',
        time: 'Talebiniz onaylandı',
        isCompleted: true,
      ));
      steps.add(_TimelineStepData(
        title: 'Tamamlanıyor',
        time: 'İşlem sürecinde',
        isCompleted: false,
        isCurrent: true,
      ));
    } else if (request.status == 'rejected') {
      steps.add(_TimelineStepData(
        title: 'Reddedildi',
        time: 'Talebiniz değerlendirme sonucu reddedildi',
        isCompleted: true,
        isRejected: true,
      ));
    } else if (request.status == 'completed') {
      steps.add(_TimelineStepData(
        title: 'Onaylandı',
        time: 'Talep onaylandı',
        isCompleted: true,
      ));
      steps.add(_TimelineStepData(
        title: 'Tamamlandı',
        time: 'Talebiniz başarıyla tamamlandı',
        isCompleted: true,
      ));
    }

    return List.generate(steps.length, (i) {
      final step = steps[i];
      return _TimelineStep(
        title: step.title,
        time: step.time,
        isCompleted: step.isCompleted,
        isLast: i == steps.length - 1,
        isCurrent: step.isCurrent,
        isRejected: step.isRejected,
      );
    });
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'approved':
        return _StatusInfo('Onaylandı', Colors.green);
      case 'rejected':
        return _StatusInfo('Reddedildi', Colors.red);
      case 'completed':
        return _StatusInfo('Tamamlandı', Colors.blue);
      case 'pending':
      default:
        return _StatusInfo('İnceleniyor', Colors.orange);
    }
  }

  String _getCategoryLabel(String type) {
    switch (type) {
      case 'items': return 'Eşya / Malzeme';
      case 'health': return 'Sağlık';
      case 'education': return 'Eğitim';
      case 'food': return 'Erzak';
      case 'other': return 'Diğer';
      default: return type;
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  _StatusInfo(this.label, this.color);
}

class _TimelineStepData {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final bool isRejected;

  _TimelineStepData({
    required this.title,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
    this.isRejected = false,
  });
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isLast;
  final bool isCurrent;
  final bool isRejected;

  const _TimelineStep({
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.isLast,
    this.isCurrent = false,
    this.isRejected = false,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isRejected
        ? Colors.red
        : (isCompleted ? AppColors.accent : (isCurrent ? AppColors.accent : AppColors.border));

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: AppColors.surface, width: 4) : null,
                  boxShadow: (isCompleted || isCurrent)
                      ? [BoxShadow(color: dotColor.withOpacity(0.5), blurRadius: 10)]
                      : null,
                ),
                child: isCompleted
                    ? Icon(
                        isRejected ? Icons.close : Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isRejected ? Colors.red : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCurrent ? Colors.amber : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
