import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/athkar/presentation/screens/athkar_home_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/tasbih/presentation/screens/tasbih_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PrayerTimesScreen(),
    PlaceholderQiblaScreen(),
    QuranHomeScreen(),
    AthkarHomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.backgroundWhite,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          _navItem(Icons.home_outlined, Icons.home, 'Home'),
          _navItem(Icons.access_time_outlined, Icons.access_time, 'Prayers'),
          _navItem(Icons.explore_outlined, Icons.explore, 'Qibla'),
          _navItem(Icons.menu_book_outlined, Icons.menu_book, 'Quran'),
          _navItem(Icons.favorite_outline, Icons.favorite, 'Athkar'),
          _navItem(Icons.more_horiz, Icons.more_horiz, 'More'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      IconData outlined, IconData filled, String label) {
    return BottomNavigationBarItem(
      icon: Icon(outlined),
      activeIcon: Icon(filled),
      label: label,
    );
  }
}

// Placeholder for Qibla screen
class PlaceholderQiblaScreen extends StatelessWidget {
  const PlaceholderQiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 64, color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text('Qibla Direction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
