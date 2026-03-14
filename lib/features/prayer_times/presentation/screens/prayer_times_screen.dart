import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../../../core/widgets/location_permission_dialog.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../providers/prayer_times_provider.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    final locationService = ref.read(locationServiceProvider);
    final permission = await locationService.checkPermission();

    if (permission == LocationPermission.denied) {
      if (!mounted) return;
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LocationPermissionDialog(),
      );

      if (result == true) {
        final newPermission = await locationService.requestPermission();
        if (newPermission == LocationPermission.always ||
            newPermission == LocationPermission.whileInUse) {
          ref.read(prayerTimesProvider.notifier).refresh();
        }
      }
    } else if (permission == LocationPermission.deniedForever) {
      _showDeniedForeverDialog();
    }
  }

  void _showDeniedForeverDialog() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.locationPermissionTitle),
        content: Text(l10n.locationPermissionDeniedForever),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.pop(context);
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerTimesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: prayerState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not load prayer times',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(prayerTimesProvider.notifier).refresh(),
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
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: () => ref.read(prayerTimesProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(l10n)),
          SliverToBoxAdapter(child: _buildDateCard()),
          SliverToBoxAdapter(child: _buildPrayersList(l10n)),
          SliverToBoxAdapter(child: _buildCalculationMethod(ref, l10n)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.prayerTimes, style: AppTextStyles.sectionTitle),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    prayerTimes.locationName,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    final now = DateTime.now();
    final gregorianDate = DateFormat('EEEE, MMMM d, y').format(now);
    final hijriDate = HijriDate.format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
            Column(
              children: [
                Text(gregorianDate, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  hijriDate,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayersList(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.todaysPrayers, style: AppTextStyles.cardTitle),
            const SizedBox(height: 16),
            ...prayerTimes.prayers.map((p) => _PrayerRow(prayer: p)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationMethod(WidgetRef ref, AppLocalizations l10n) {
    final method = _getMethodDisplayName(prayerTimes.calculationMethod);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent,
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
                      const Icon(
                        Icons.settings_outlined,
                        size: 16,
                        color: AppColors.primaryAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.calculationMethod,
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.usingMethodForCalculations(method),
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      l10n.changeSettings,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryAccent,
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
    final l10n = AppLocalizations.of(context)!;
    final isPast = widget.prayer.isPast;
    final timeStr = DateFormat('HH:mm').format(widget.prayer.time);
    final sizeClass = ResponsiveLayout.fromContext(context);
    final isCompact = sizeClass == ResponsiveSizeClass.compact;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.prayer.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.prayer.name,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: isPast ? AppColors.textTertiary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 42),
                  child: Text(
                    _getPrayerSubtitle(widget.prayer.name, l10n),
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      timeStr,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isPast ? AppColors.textTertiary : AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _notifEnabled
                          ? Icons.notifications_outlined
                          : Icons.notifications_off_outlined,
                      size: 18,
                      color: _notifEnabled
                          ? AppColors.primaryAccent
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _notifEnabled,
                        onChanged: (v) => setState(() => _notifEnabled = v),
                        activeThumbColor: AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Text(widget.prayer.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prayer.name,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: isPast ? AppColors.textTertiary : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _getPrayerSubtitle(widget.prayer.name, l10n),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  timeStr,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isPast ? AppColors.textTertiary : AppColors.primaryAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _notifEnabled
                      ? Icons.notifications_outlined
                      : Icons.notifications_off_outlined,
                  size: 18,
                  color: _notifEnabled
                      ? AppColors.primaryAccent
                      : AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _notifEnabled,
                    onChanged: (v) => setState(() => _notifEnabled = v),
                    activeThumbColor: AppColors.primaryAccent,
                  ),
                ),
              ],
            ),
    );
  }

  String _getPrayerSubtitle(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Fajr':
        return l10n.dawnPrayer;
      case 'Dhuhr':
        return l10n.noonPrayer;
      case 'Asr':
        return l10n.afternoonPrayer;
      case 'Maghrib':
        return l10n.sunsetPrayer;
      case 'Isha':
        return l10n.nightPrayer;
      default:
        return '';
    }
  }
}
