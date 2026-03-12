import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

import '../../features/athkar/presentation/screens/athkar_home_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_colors.dart';
import '../services/notification_service.dart';

final shellTabIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final List<Widget> _screens = const [
    HomeScreen(),
    PrayerTimesScreen(),
    QiblaScreen(),
    QuranHomeScreen(),
    AthkarHomeScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).requestPermissions();
      ref.read(settingsProvider.notifier).initializeNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(shellTabIndexProvider);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: ref.watch(shellTabIndexProvider),
        onTap: (index) =>
            ref.read(shellTabIndexProvider.notifier).state = index,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryAccent,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          _navItem(
            Icons.home_outlined,
            Icons.home,
            AppLocalizations.of(context)!.homeTab,
          ),
          _navItem(
            Icons.access_time_outlined,
            Icons.access_time,
            AppLocalizations.of(context)!.prayersTab,
          ),
          _navItem(
            Icons.explore_outlined,
            Icons.explore,
            AppLocalizations.of(context)!.qiblaTab,
          ),
          _navItem(
            Icons.menu_book_outlined,
            Icons.menu_book,
            AppLocalizations.of(context)!.quranTab,
          ),
          _navItem(
            Icons.favorite_outline,
            Icons.favorite,
            AppLocalizations.of(context)!.athkarTab,
          ),
          _navItem(
            Icons.more_horiz,
            Icons.more_horiz,
            AppLocalizations.of(context)!.moreTab,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    IconData outlined,
    IconData filled,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(outlined),
      activeIcon: Icon(filled),
      label: label,
    );
  }
}
