import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_provider.dart';
import 'quran_reader_screen.dart';

class JuzIndexScreen extends ConsumerWidget {
  const JuzIndexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final juzAsync = ref.watch(allJuzProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Juz Index', style: AppTextStyles.cardTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: juzAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
        error: (e, st) => Center(child: Text('Error loading Juz data: $e')),
        data: (juzList) {
          if (juzList.isEmpty) {
            return const Center(child: Text('No Juz data loaded.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: juzList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final juz = juzList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    ref
                        .read(quranReaderProvider.notifier)
                        .goToPage(juz.startPage);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuranReaderScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${juz.juzNumber}',
                              style: AppTextStyles.cardTitle.copyWith(
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Juz ${juz.juzNumber}',
                                style: AppTextStyles.cardTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Page ${juz.startPage}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          juz.nameArabic,
                          style: AppTextStyles.arabicLarge.copyWith(
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
