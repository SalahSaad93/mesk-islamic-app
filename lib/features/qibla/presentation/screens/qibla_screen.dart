import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/qibla_provider.dart';

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qiblaStateRaw = ref.watch(qiblaProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.qiblaDirection, style: AppTextStyles.cardTitle),
        backgroundColor: AppColors.surface,
        centerTitle: true,
        elevation: 0,
      ),
      body: qiblaStateRaw.when(
        data: (qiblaState) {
          if (qiblaState.hasError) {
            return _buildErrorState(qiblaState.errorMessage, l10n);
          }
          return _buildCompass(context, qiblaState, l10n);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
        error: (err, stack) => _buildErrorState(err.toString(), l10n),
      ),
    );
  }

  Widget _buildErrorState(String error, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              l10n.failedToLoadQibla,
              style: AppTextStyles.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.ensurePermissions,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(
    BuildContext context,
    QiblaState state,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    final compassSize = isCompact ? 240.0 : 300.0;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Informative header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              l10n.alignArrowToKaaba,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: isCompact ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.qiblaDegrees(state.qiblaDirection.toStringAsFixed(1)),
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.primaryAccent,
              fontSize: isCompact ? 20 : 24,
            ),
          ),
          const SizedBox(height: 48),

          // The Compass
          Stack(
            alignment: Alignment.center,
            children: [
              // Compass Dial
              Transform.rotate(
                // Rotate dial based on device heading (in radians)
                angle: (state.currentHeading * (math.pi / 180) * -1),
                child: Container(
                  width: compassSize,
                  height: compassSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 2),
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // North indicator
                      Positioned(
                        top: 10,
                        child: Text(
                          'N',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.primaryAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: isCompact ? 16 : 18,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Text(
                          'S',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isCompact ? 16 : 18,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        child: Text(
                          'E',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isCompact ? 16 : 18,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        child: Text(
                          'W',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isCompact ? 16 : 18,
                          ),
                        ),
                      ),

                      // Marks
                      for (int i = 0; i < 360; i += 15)
                        Transform.rotate(
                          angle: i * math.pi / 180,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: i % 90 == 0 ? 4 : 2,
                              height: i % 90 == 0 ? 12 : 8,
                              decoration: BoxDecoration(
                                color: i % 90 == 0
                                    ? AppColors.textPrimary
                                    : AppColors.border,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Qibla Pointer (Rotates relative to dial)
              Transform.rotate(
                // The Qibla angle is absolute (relative to North),
                // so we rotate it by (Qibla Direction - Current Heading)
                angle:
                    ((state.qiblaDirection - state.currentHeading) *
                    (math.pi / 180)),
                child: Icon(
                  Icons.navigation,
                  size: isCompact ? 100 : 140,
                  color: AppColors.primaryAccent,
                ),
              ),

              // Center pivot
              Container(
                width: isCompact ? 14 : 16,
                height: isCompact ? 14 : 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
