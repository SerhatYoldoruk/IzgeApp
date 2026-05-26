import 'package:flutter/material.dart';

import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/home/presentation/pages/home_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_screen.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/request_screen.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/surveys_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/profile_screen.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Etkinlikler', style: TextStyle(color: AppColors.accent))),
      body: Center(child: Text('Etkinlikler Ekranı Yakında...', style: TextStyle(color: AppColors.textPrimary))),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late PageController _pageController;



  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    ThemeController.instance.addListener(_onThemeChanged);
    LanguageController.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    ThemeController.instance.removeListener(_onThemeChanged);
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      NewsScreen(),
      RequestsScreen(),
      SurveysScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Ekstra akıcı bir kaydırma efekti için
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.textPrimary.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'Anasayfa'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.newspaper_outlined),
              activeIcon: const Icon(Icons.newspaper),
              label: 'Haberler'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.description_outlined),
              activeIcon: const Icon(Icons.description),
              label: 'Talepler'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.poll_outlined),
              activeIcon: const Icon(Icons.poll),
              label: 'Anketler'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'Profil'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
