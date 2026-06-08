import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/new_event_screen.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/event_detail_screen.dart';

import 'package:izge_app_frontend/core/widgets/notification_badge_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_state.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR');
    LanguageController.instance.addListener(_onLanguageChanged);
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
          const NotificationBadgeIcon(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Section
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Sağa kaydırma -> Önceki Ay
                  setState(() {
                    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
                  });
                } else if (details.primaryVelocity! < 0) {
                  // Sola kaydırma -> Sonraki Ay
                  setState(() {
                    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
                  });
                }
              },
              child: Container(
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
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _focusedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              locale: LanguageController.instance.isTurkish ? const Locale('tr', 'TR') : const Locale('en', 'US'),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ThemeController.instance.isDarkMode
                                      ? ColorScheme.dark(
                                          primary: AppColors.accent,
                                          onPrimary: Colors.black,
                                          surface: AppColors.surfaceElevated,
                                          onSurface: Colors.white,
                                        )
                                      : ColorScheme.light(
                                          primary: AppColors.accent,
                                          onPrimary: Colors.black,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                    dialogBackgroundColor: AppColors.surface,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                _focusedDate = picked;
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                DateFormat('MMMM yyyy', LanguageController.instance.isTurkish ? 'tr_TR' : 'en_US').format(_focusedDate),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: AppColors.accent),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: AppColors.accent),
                            onPressed: () {
                              setState(() {
                                _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: AppColors.accent),
                            onPressed: () {
                              setState(() {
                                _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildCalendarDays(),
                  const SizedBox(height: 16),
                  BlocBuilder<EventBloc, EventState>(
                    builder: (context, state) {
                      return _buildCalendarGrid(state);
                    },
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günün Etkinlikleri'.tr(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  LanguageController.instance.isTurkish 
                    ? DateFormat("d MMMM yyyy, EEEE", 'tr_TR').format(_selectedDate)
                    : DateFormat("MMMM d, yyyy - EEEE", 'en_US').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
                } else if (state is EventLoaded) {
                  final filteredEvents = state.events.where((e) => 
                      e.eventDate.year == _selectedDate.year && 
                      e.eventDate.month == _selectedDate.month && 
                      e.eventDate.day == _selectedDate.day).toList();

                  if (filteredEvents.isEmpty) {
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
                              'Bu tarihte planlanmış bir etkinlik yok'.tr(),
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: filteredEvents.map((event) {
                      final dayStr = event.eventDate.day.toString();
                      final monthStr = DateFormat('MMM', 'tr_TR').format(event.eventDate).toUpperCase();
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailScreen(event: event),
                              ),
                            );
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

  Widget _buildCalendarGrid(EventState state) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final firstWeekdayOffset = firstDayOfMonth.weekday - 1; // 0 for Monday, 6 for Sunday

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth + firstWeekdayOffset,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < firstWeekdayOffset) {
          return const SizedBox();
        }

        final day = index - firstWeekdayOffset + 1;
        final dayStr = day.toString();
        final isSelected = _selectedDate.year == _focusedDate.year && _selectedDate.month == _focusedDate.month && _selectedDate.day == day;
        final isToday = DateTime.now().year == _focusedDate.year && DateTime.now().month == _focusedDate.month && DateTime.now().day == day;
        
        bool hasEvent = false;
        if (state is EventLoaded) {
          hasEvent = state.events.any((e) => 
            e.eventDate.year == _focusedDate.year && 
            e.eventDate.month == _focusedDate.month && 
            e.eventDate.day == day);
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, day);
            });
          },
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.accentDark,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.2),
                        blurRadius: 8,
                      )
                    ],
                  )
                : (isToday ? BoxDecoration(
                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ) : null),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayStr,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasEvent && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    )
                ],
              ),
            ),
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
