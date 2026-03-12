import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_audio_provider.dart';
import '../providers/reciter_provider.dart';

class ReciterPickerSheet extends ConsumerWidget {
  const ReciterPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recitersAsync = ref.watch(recitersProvider);
    final audioState = ref.watch(quranAudioProvider);

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
            child: Text('Select Reciter', style: AppTextStyles.cardTitle),
          ),
          const SizedBox(height: 16),
          recitersAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (reciters) => Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: reciters.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final r = reciters[index];
                  final isSelected = r.id == audioState.selectedReciter?.id;

                  return ListTile(
                    onTap: () {
                      ref.read(quranAudioProvider.notifier).changeReciter(r);
                      Navigator.pop(context);
                    },
                    tileColor: isSelected
                        ? AppColors.primaryAccent.withValues(alpha: 0.1)
                        : null,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryAccent.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        r.nameEnglish[0],
                        style: const TextStyle(color: AppColors.primaryAccent),
                      ),
                    ),
                    title: Text(
                      r.nameEnglish,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      r.nameArabic,
                      style: AppTextStyles.arabicSmall.copyWith(fontSize: 12),
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryAccent,
                          )
                        : null,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
