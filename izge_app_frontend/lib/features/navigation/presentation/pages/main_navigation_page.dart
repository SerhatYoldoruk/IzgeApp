import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/home/presentation/pages/home_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_screen.dart';
import 'package:izge_app_frontend/features/navigation/presentation/pages/tools_hub_screen.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/surveys_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/profile_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Etkinlikler'.tr(), style: TextStyle(color: AppColors.accent))),
      body: Center(child: Text('Etkinlikler Ekranı Yakında...'.tr(), style: TextStyle(color: AppColors.textPrimary))),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  late final PageController _pageController;

  final List<Widget> _screens = [
    HomeScreen(),
    NewsScreen(),
    ToolsHubScreen(),
    SurveysScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _screens,
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
          selectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
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
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore),
              label: 'Keşfet'.tr().tr(),
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
