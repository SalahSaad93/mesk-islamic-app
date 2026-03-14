import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class TafsirBottomSheet extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final String textUthmani;

  const TafsirBottomSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textUthmani,
  });

  @override
  Widget build(BuildContext context) {
    // In a real implementation, you would fetch Tafsir data from a database/API
    // based on surahNumber and ayahNumber.
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
            'Tafsir (Surah $surahNumber, Ayah $ayahNumber)',
            style: AppTextStyles.cardTitle,
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
            child: SingleChildScrollView(
              child: Text(
                'Tafsir Ibn Kathir (or other source) text goes here. Currently using placeholder text since true Tafsir database is large. It provides context, translation, and interpretation for the selected Ayah.',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
