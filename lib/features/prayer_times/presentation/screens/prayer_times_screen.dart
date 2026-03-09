import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';
import '../providers/prayer_times_provider.dart';
import '../../domain/entities/prayer_times_entity.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerState = ref.watch(prayerTimesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: prayerState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text('Could not load prayer times', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.read(prayerTimesProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (prayerTimes) => _PrayerTimesContent(prayerTimes: prayerTimes),
        ),
      ),
    );
  }
}

class _PrayerTimesContent extends ConsumerWidget {
  final PrayerTimesEntity prayerTimes;
  const _PrayerTimesContent({required this.prayerTimes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildDateCard()),
        SliverToBoxAdapter(child: _buildPrayersList()),
        SliverToBoxAdapter(child: _buildCalculationMethod(ref)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prayer Times', style: AppTextStyles.headlineLarge),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(prayerTimes.locationName,
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.textMedium),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    final now = DateTime.now();
    final gregorianDate = DateFormat('EEEE, MMMM d, y').format(now);
    final hijriDate = _getHijriDate(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IslamicCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textMedium),
              onPressed: () {},
            ),
            Column(
              children: [
                Text(gregorianDate, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 4),
                Text(hijriDate,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.primaryGreen)),
              ],
            ),
            IconButton(
              icon:
                  const Icon(Icons.chevron_right, color: AppColors.textMedium),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayersList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IslamicCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Prayers", style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            ...prayerTimes.prayers
                .map((p) => _PrayerRow(prayer: p))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationMethod(WidgetRef ref) {
    final method = _getMethodDisplayName(prayerTimes.calculationMethod);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IslamicCard(
        padding: const EdgeInsets.all(16),
        borderColor: AppColors.primaryGreen.withOpacity(0.3),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings_outlined,
                          size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 6),
                      Text('Calculation Method',
                          style: AppTextStyles.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Using $method method for prayer time calculations.',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Change settings',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHijriDate(DateTime date) {
    // Simple Hijri date approximation
    final hijriOffset = 578;
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
      return 'Hijri Date';
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

  String _getMethodDisplayName(String method) {
    switch (method) {
      case 'UmmAlQura':
        return 'Umm Al-Qura University, Makkah';
      case 'Egyptian':
        return 'Egyptian General Authority of Survey';
      case 'Karachi':
        return 'University of Islamic Sciences, Karachi';
      case 'MWL':
        return 'Muslim World League';
      case 'Tehran':
        return 'Institute of Geophysics, Tehran';
      default:
        return 'Islamic Society of North America (ISNA)';
    }
  }
}

class _PrayerRow extends StatefulWidget {
  final PrayerEntry prayer;
  const _PrayerRow({required this.prayer});

  @override
  State<_PrayerRow> createState() => _PrayerRowState();
}

class _PrayerRowState extends State<_PrayerRow> {
  bool _notifEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isPast = widget.prayer.isPast;
    final timeStr = DateFormat('HH:mm').format(widget.prayer.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(widget.prayer.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.prayer.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: isPast ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                Text(
                  _getPrayerSubtitle(widget.prayer.name),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: AppTextStyles.prayerTime.copyWith(
              color: isPast ? AppColors.textLight : AppColors.primaryGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            _notifEnabled ? Icons.notifications_outlined : Icons.notifications_off_outlined,
            size: 18,
            color: _notifEnabled ? AppColors.primaryGreen : AppColors.textLight,
          ),
          const SizedBox(width: 4),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _notifEnabled,
              onChanged: (v) => setState(() => _notifEnabled = v),
              activeColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerSubtitle(String name) {
    switch (name) {
      case 'Fajr':
        return 'Dawn Prayer';
      case 'Dhuhr':
        return 'Noon Prayer';
      case 'Asr':
        return 'Afternoon Prayer';
      case 'Maghrib':
        return 'Sunset Prayer';
      case 'Isha':
        return 'Night Prayer';
      default:
        return '';
    }
  }
}
