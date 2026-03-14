import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_tafsir_provider.dart';

class TafsirBottomSheet extends ConsumerWidget {
  final int surahNumber;
  final int ayahNumber;
  final String textUthmani;

  const TafsirBottomSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textUthmani,
  });

  int get _verseId => (surahNumber - 1) * 100 + ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync = ref.watch(tafsirProvider(_verseId));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Tafsir Ibn Kathir',
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),
          Text(
            'Surah $surahNumber, Ayah $ayahNumber',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            textUthmani,
            style: AppTextStyles.arabicLarge.copyWith(
              color: AppColors.primaryAccent,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: tafsirAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load tafsir',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(tafsirProvider(_verseId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (tafsir) => SingleChildScrollView(
                child: Text(
                  tafsir?.text ?? 'No tafsir available for this verse.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
