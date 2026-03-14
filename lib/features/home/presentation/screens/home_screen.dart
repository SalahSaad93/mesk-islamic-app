import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/navigation/app_shell.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/background_blobs.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../../prayer_times/domain/entities/prayer_times_entity.dart';
import '../../../prayer_times/presentation/providers/prayer_times_provider.dart';
import '../widgets/daily_inspiration_widget.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final sizeClass = ResponsiveLayout.fromContext(context);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          BackgroundBlobsLayer(
            blobs: const [
              BackgroundBlob(
                color: AppColors.primaryAccent,
                position: Alignment(-1.2, -0.5),
              ),
              BackgroundBlob(
                color: AppColors.secondaryAccent,
                position: Alignment(1.3, 0.8),
              ),
            ],
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(prayerState, sizeClass)),
                SliverToBoxAdapter(
                  child: prayerState.when(
                    loading: () => _buildPrayerCardLoading(),
                    error: (_, _) => _buildPrayerCardError(l10n),
                    data: (times) =>
                        _buildCurrentPrayerCard(times, l10n, sizeClass),
                  ),
                ),
                SliverToBoxAdapter(
                  child: prayerState.when(
                    loading: () => const SizedBox(),
                    error: (_, _) => const SizedBox(),
                    data: (times) =>
                        _buildUpcomingPrayers(times, l10n, sizeClass),
                  ),
                ),
                SliverToBoxAdapter(child: _buildQuickAccess(l10n, sizeClass)),
                const SliverToBoxAdapter(child: DailyInspirationWidget()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue prayerState, ResponsiveSizeClass sizeClass) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE, MMM d').format(now);
    final hijriDate = HijriDate.format(now, fallback: 'Hijri');
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
                  AppLocalizations.of(context)!.assalamuAlaikum,
                  style: AppTextStyles.heroTitle.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dayName, style: AppTextStyles.bodySmall),
                  Text(
                    hijriDate,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(locationName, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPrayerCard(
    PrayerTimesEntity times,
    AppLocalizations l10n,
    ResponsiveSizeClass sizeClass,
  ) {
    final nextPrayer = times.nextPrayer;
    if (nextPrayer == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.currentPrayer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nextPrayer.name,
              style: AppTextStyles.countdownTimer.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<Duration>(
              stream: _countdownStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? times.timeUntilNextPrayer;
                final h = duration.inHours;
                final m = duration.inMinutes % 60;
                return Text(
                  '${h}h ${m}m',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
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
      child: ClayCard(
        child: const SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerCardError(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClayCard(
        child: const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'Enable location for prayer times',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingPrayers(
    PrayerTimesEntity times,
    AppLocalizations l10n,
    ResponsiveSizeClass sizeClass,
  ) {
    final upcoming = times.prayers.where((p) => !p.isPast).toList();
    if (upcoming.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 8),
                Text(l10n.upcomingPrayers, style: AppTextStyles.cardTitle),
              ],
            ),
            const SizedBox(height: 12),
            ...upcoming
                .take(4)
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(p.name, style: AppTextStyles.bodyLarge),
                        ),
                        Text(
                          DateFormat('HH:mm').format(p.time),
                          style: AppTextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess(
    AppLocalizations l10n,
    ResponsiveSizeClass sizeClass,
  ) {
    final isCompact = sizeClass == ResponsiveSizeClass.compact;
    final isLandscape = ResponsiveLayout.isLandscape(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(l10n.quickAccess, style: AppTextStyles.cardTitle),
          ),
          if (isLandscape && !isCompact)
            Row(
              children: [
                Expanded(
                  child: _ClayQuickAccessItem(
                    icon: Icons.explore_outlined,
                    label: l10n.qiblaTab,
                    subtitle: l10n.qiblaDirection,
                    gradient: const LinearGradient(
                      colors: [Color(0x0fff4a26), AppColors.primaryAccent],
                    ),
                    onTap: () {
                      ref.read(shellTabIndexProvider.notifier).state =
                          2; // Qibla tab index
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ClayQuickAccessItem(
                    icon: Icons.menu_book_outlined,
                    label: l10n.quranTab,
                    subtitle: l10n.holyBook,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), AppColors.tertiaryAccent],
                    ),
                    onTap: () {
                      ref.read(shellTabIndexProvider.notifier).state =
                          3; // Quran tab index
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ClayQuickAccessItem(
                    icon: Icons.favorite_outline,
                    label: l10n.athkarTab,
                    subtitle: l10n.supplications,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), AppColors.secondaryAccent],
                    ),
                    onTap: () {
                      ref.read(shellTabIndexProvider.notifier).state =
                          4; // Athkar tab index
                    },
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _ClayQuickAccessItem(
                  icon: Icons.explore_outlined,
                  label: l10n.qiblaTab,
                  subtitle: l10n.qiblaDirection,
                  gradient: const LinearGradient(
                    colors: [Color(0x0fff4a26), AppColors.primaryAccent],
                  ),
                  onTap: () {
                    ref.read(shellTabIndexProvider.notifier).state =
                        2; // Qibla tab index
                  },
                ),
                const SizedBox(height: 12),
                _ClayQuickAccessItem(
                  icon: Icons.menu_book_outlined,
                  label: l10n.quranTab,
                  subtitle: l10n.holyBook,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), AppColors.tertiaryAccent],
                  ),
                  onTap: () {
                    ref.read(shellTabIndexProvider.notifier).state =
                        3; // Quran tab index
                  },
                ),
                const SizedBox(height: 12),
                _ClayQuickAccessItem(
                  icon: Icons.favorite_outline,
                  label: l10n.athkarTab,
                  subtitle: l10n.supplications,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), AppColors.secondaryAccent],
                  ),
                  onTap: () {
                    ref.read(shellTabIndexProvider.notifier).state =
                        4; // Athkar tab index
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedLayout(
    PrayerTimesEntity times,
    AppLocalizations l10n,
    ResponsiveSizeClass sizeClass,
  ) {
    final upcoming = times.prayers.where((p) => !p.isPast).toList();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildUpcomingPrayers(times, l10n, sizeClass),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickAccess(l10n, sizeClass),
          ),
        ],
      ),
    );
  }
}

class _ClayQuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ClayQuickAccessItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: onTap,
      liftOnTap: true,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
