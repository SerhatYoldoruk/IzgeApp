import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/models/request_model.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/new_request_screen.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/request_detail_screen.dart';

class PastRequestsScreen extends StatefulWidget {
  const PastRequestsScreen({super.key});

  @override
  State<PastRequestsScreen> createState() => _PastRequestsScreenState();
}

class _PastRequestsScreenState extends State<PastRequestsScreen> {
  late Future<List<RequestModel>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = SupabaseService.instance.getRequests();
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
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Geçmiş Talepler'.tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          setState(() {
            _requestsFuture = SupabaseService.instance.getRequests();
          });
        },
        child: FutureBuilder<List<RequestModel>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final requests = snapshot.data ?? [];

            if (requests.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];

                  IconData reqIcon = Icons.list_alt;
                  switch (req.requestType) {
                    case 'items': reqIcon = Icons.inventory_2; break;
                    case 'health': reqIcon = Icons.medical_services; break;
                    case 'education': reqIcon = Icons.school; break;
                    case 'food': reqIcon = Icons.fastfood; break;
                  }

                  Color statColor = Colors.orange;
                  String statText = 'İnceleniyor';
                  if (req.status == 'approved') { statColor = Colors.green; statText = 'Onaylandı'; }
                  if (req.status == 'rejected') { statColor = Colors.red; statText = 'Reddedildi'; }
                  if (req.status == 'completed') { statColor = Colors.blue; statText = 'Tamamlandı'; }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RequestDetailScreen(request: req)),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(reqIcon, color: AppColors.accent, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(color: statColor, shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(statText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                                      const Spacer(),
                                      Text(
                                        DateFormat('d MMM yyyy', 'tr_TR').format(req.createdAt),
                                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.list_alt, size: 60, color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Henüz Bir Talep Oluşturmadınız'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'İhtiyaç duyduğunuz konularda talep oluşturarak bizden destek alabilirsiniz.'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const NewRequestScreen()));
                          if (mounted) {
                            setState(() {
                              _requestsFuture = SupabaseService.instance.getRequests();
                            });
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Yeni Talep Oluştur'.tr(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A8025),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
