import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/new_event_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_state.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR');
    LanguageController.instance.addListener(_onLanguageChanged);
    _currentDate = DateTime.now();
  }

  @override
  void dispose() {
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPrevMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _onNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewEventScreen()));
        },
        backgroundColor: AppColors.accent,
        child: Icon(Icons.add, color: Color(0xFF003908)),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/images/logo.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Etkinlik Takvimi'.tr(),
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Section (Simplified for UI representation)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                          DateFormat('MMMM yyyy', LanguageController.instance.isTurkish ? 'tr_TR' : 'en_US')
                              .format(_currentDate),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      Row(
                        children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left, color: AppColors.accent),
                              onPressed: _onPrevMonth,
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right, color: AppColors.accent),
                              onPressed: _onNextMonth,
                            ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildCalendarDays(),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Günün Etkinlikleri'.tr(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${LanguageController.instance.isTurkish ? 'Bugün, ' : 'Today, '}'
                  '${DateFormat('d MMMM', LanguageController.instance.isTurkish ? 'tr_TR' : 'en_US').format(DateTime.now())}'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventError) {
                  return Center(
                    child: Text(
                      'Etkinlikler yüklenirken hata oluştu: '.tr() + state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is EventLoaded) {
                  if (state.events.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_available,
                              color: AppColors.textSecondary,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Henüz planlanmış bir etkinlik yok'.tr(),
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: state.events.map((event) {
                      final dayStr = event.eventDate.day.toString();
                      final monthStr = DateFormat('MMM', LanguageController.instance.isTurkish ? 'tr_TR' : 'en_US').format(event.eventDate).toUpperCase();
                      final timeStr = DateFormat('HH:mm').format(event.eventDate);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _EventCard(
                          day: dayStr,
                          month: monthStr,
                          title: event.title,
                          timeOrLocation: '$timeStr • ${event.location ?? 'Çevrimiçi'}',
                          icon: event.location != null ? Icons.location_on : Icons.laptop_chromebook,
                          accentColor: AppColors.accent,
                          onTap: () {
                            // Detay sayfasına model yollanacak şekilde ayarlanabilir
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDays() {
    final days = LanguageController.instance.isTurkish
        ? ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz']
        : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => Text(
                day,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    // Generate a list of days to display for the current month, including leading empty cells.
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(_currentDate.year, _currentDate.month);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Make Sunday = 0
    final totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekday + 1;
        final isInMonth = dayNumber > 0 && dayNumber <= daysInMonth;
        final isToday = isInMonth &&
            dayNumber == DateTime.now().day &&
            _currentDate.month == DateTime.now().month &&
            _currentDate.year == DateTime.now().year;

        return Container(
          decoration: isToday
              ? BoxDecoration(
                  color: AppColors.accentDark,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                )
              : null,
          child: Center(
            child: isInMonth
                ? Text(
                    dayNumber.toString(),
                    style: TextStyle(
                      color: isToday ? Colors.white : AppColors.textPrimary,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final String day;
  final String month;
  final String title;
  final String timeOrLocation;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _EventCard({
    required this.day,
    required this.month,
    required this.title,
    required this.timeOrLocation,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(icon, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        timeOrLocation,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    ),
    );
  }
}
