import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/verse_entity.dart';
import '../providers/quran_preferences_provider.dart';

class VerseModeCard extends ConsumerWidget {
  final VerseEntity verse;

  const VerseModeCard({super.key, required this.verse});

  static const List<double> fontSizeValues = [24.0, 28.0, 32.0, 38.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(quranPreferencesProvider);
    final fontSize = fontSizeValues[preferences.fontSize - 1];
    
    final backgroundColor = preferences.nightMode 
        ? const Color(0xFF1E1E1E) 
        : AppColors.surface;
    final textColor = preferences.nightMode 
        ? Colors.white 
        : AppColors.textPrimary;

    return Semantics(
      label: 'Surah ${verse.surahNumber} Ayah ${verse.ayahNumber}',
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Surah name header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Surah ${verse.surahNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: preferences.nightMode 
                        ? Colors.white70 
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${verse.surahNumber}',
                    style: AppTextStyles.arabicSmall.copyWith(
                      color: AppColors.primaryAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Arabic verse text
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    verse.textUthmani.isNotEmpty 
                        ? verse.textUthmani 
                        : 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Amiri',
                      color: textColor,
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ayah number badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_quote,
                    size: 16,
                    color: AppColors.primaryAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ayah ${verse.ayahNumber}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w600,
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
}
