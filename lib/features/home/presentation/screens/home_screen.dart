import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';
import '../../../prayer_times/presentation/providers/prayer_times_provider.dart';
import '../../../prayer_times/domain/entities/prayer_times_entity.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream<Duration> _countdownStream;

  @override
  void initState() {
    super.initState();
    _countdownStream = Stream.periodic(const Duration(seconds: 1), (_) {
      final state = ref.read(prayerTimesProvider);
      return state.valueOrNull?.timeUntilNextPrayer ?? Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerTimesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(prayerState)),
            SliverToBoxAdapter(
                child: prayerState.when(
              loading: () => _buildPrayerCardLoading(),
              error: (_, __) => _buildPrayerCardError(),
              data: (times) => _buildCurrentPrayerCard(times),
            )),
            SliverToBoxAdapter(
                child: prayerState.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (times) => _buildUpcomingPrayers(times),
            )),
            SliverToBoxAdapter(child: _buildQuickAccess()),
            SliverToBoxAdapter(child: _buildDailyInspiration()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue prayerState) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE, MMM d').format(now);
    final hijriDate = _getHijriDateShort(now);
    final locationName = prayerState.valueOrNull?.locationName ?? '...';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Assalamu Alaikum',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dayName, style: AppTextStyles.bodySmall),
                  Text(hijriDate,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primaryGreen)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(locationName, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPrayerCard(PrayerTimesEntity times) {
    final nextPrayer = times.nextPrayer;
    if (nextPrayer == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryGreen, AppColors.primaryGreenLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text('Current Prayer',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextPrayer.name,
                    style: AppTextStyles.headlineLarge
                        .copyWith(color: Colors.white, fontSize: 26),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Next: ${DateFormat('HH:mm').format(nextPrayer.time)}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            StreamBuilder<Duration>(
              stream: _countdownStream,
              builder: (context, snapshot) {
                final duration = times.timeUntilNextPrayer;
                final h = duration.inHours;
                final m = duration.inMinutes % 60;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${h}h ${m}m',
                      style: AppTextStyles.headlineLarge
                          .copyWith(color: Colors.white, fontSize: 28),
                    ),
                    Text('remaining',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCardLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPrayerCardError() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text('Enable location for prayer times',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.primaryGreen)),
        ),
      ),
    );
  }

  Widget _buildUpcomingPrayers(PrayerTimesEntity times) {
    final upcoming = times.prayers.where((p) => !p.isPast).toList();
    if (upcoming.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IslamicCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: AppColors.textDark),
                const SizedBox(width: 8),
                Text('Upcoming Prayers', style: AppTextStyles.headlineSmall),
              ],
            ),
            const SizedBox(height: 12),
            ...upcoming.take(4).map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(p.name, style: AppTextStyles.bodyLarge),
                      ),
                      Text(
                        DateFormat('HH:mm').format(p.time),
                        style: AppTextStyles.prayerTime,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Quick Access', style: AppTextStyles.headlineSmall),
          ),
          Row(
            children: [
              Expanded(
                  child: _QuickAccessItem(
                icon: Icons.explore_outlined,
                label: 'Qibla',
                subtitle: 'Find direction',
                color: const Color(0xFF4CAF50),
                onTap: () {},
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _QuickAccessItem(
                icon: Icons.menu_book_outlined,
                label: 'Quran',
                subtitle: 'Holy book',
                color: const Color(0xFF2196F3),
                onTap: () {},
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _QuickAccessItem(
                icon: Icons.favorite_outline,
                label: 'Athkar',
                subtitle: 'Supplications',
                color: const Color(0xFFE91E63),
                onTap: () {},
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInspiration() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IslamicCard(
        borderColor: AppColors.goldAccent.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text('Daily Inspiration',
                    style: AppTextStyles.headlineSmall),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
                style: AppTextStyles.arabicBody.copyWith(
                  color: AppColors.textDark,
                  fontSize: 20,
                ),
                textDirection: ui.TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '"And whoever fears Allah - He will make for him a way out."',
              style: AppTextStyles.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quran 65:2',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHijriDateShort(DateTime date) {
    final julianDay = _toJulianDay(date);
    final hijriDay = julianDay - 1948440 + 10632;
    final n = ((hijriDay - 1) ~/ 10631);
    final hijriDay2 = hijriDay - 10631 * n + 354;
    final j = ((10985 - hijriDay2) ~/ 5316) * ((50 * hijriDay2) ~/ 17719) +
        (hijriDay2 ~/ 5670) * ((43 * hijriDay2) ~/ 15238);
    final hijriDay3 = hijriDay2 -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * hijriDay3) ~/ 709;
    final day = hijriDay3 - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    final hijriMonths = [
      'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
      "Jumada al-Ula", "Jumada al-Akhirah", 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", "Dhu al-Hijjah"
    ];

    try {
      final monthName = hijriMonths[(month - 1).clamp(0, 11)];
      return '$day $monthName $year';
    } catch (_) {
      return 'Hijri';
    }
  }

  int _toJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: AppTextStyles.labelLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(subtitle,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
