import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../../../core/utils/daily_verse_helper.dart';

class DailyInspirationWidget extends ConsumerWidget {
  const DailyInspirationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyVerseAsync = ref.watch(dailyVerseProvider);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surfaceLite,
        child: dailyVerseAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            ),
          ),
          error: (e, st) => const SizedBox(),
          data: (dailyVerse) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(l10n.dailyInspiration, style: AppTextStyles.labelLarge),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dailyVerse.arabicText,
                  style: AppTextStyles.arabicBody.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textDirection: ui.TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dailyVerse.translation,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dailyVerse.reference,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
