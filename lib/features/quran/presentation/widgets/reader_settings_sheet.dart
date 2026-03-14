import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_preferences_provider.dart';

class ReaderSettingsSheet extends ConsumerWidget {
  const ReaderSettingsSheet({super.key});

  static const List<String> fontSizeLabels = ['Small', 'Medium', 'Large', 'XLarge'];
  static const List<double> fontSizeValues = [24.0, 28.0, 32.0, 38.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(quranPreferencesProvider);
    final prefsNotifier = ref.read(quranPreferencesProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Reader Settings', style: AppTextStyles.cardTitle),
          ),
          const SizedBox(height: 24),
          
          // Font Size Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Font Size', style: AppTextStyles.bodyMedium),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(4, (index) {
                final isSelected = preferences.fontSize == index + 1;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => prefsNotifier.setFontSize(index + 1),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primaryAccent 
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.primaryAccent 
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            fontSizeLabels[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? Colors.white 
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${fontSizeValues[index].toInt()}px',
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected 
                                  ? Colors.white70 
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Preview Text
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontSize: fontSizeValues[preferences.fontSize - 1],
                  fontFamily: 'Amiri',
                  color: AppColors.textPrimary,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Night Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      preferences.nightMode 
                          ? Icons.dark_mode 
                          : Icons.light_mode,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Night Mode',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                Switch(
                  value: preferences.nightMode,
                  onChanged: (_) => prefsNotifier.toggleNightMode(),
                  activeColor: AppColors.primaryAccent,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Show Translation Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.translate,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Show Translation',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                Switch(
                  value: preferences.showTranslation,
                  onChanged: (value) => prefsNotifier.setShowTranslation(value),
                  activeColor: AppColors.primaryAccent,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

void showReaderSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ReaderSettingsSheet(),
  );
}
