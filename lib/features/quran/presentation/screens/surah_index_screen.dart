import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/surah_entity.dart';
import '../providers/quran_provider.dart';
import 'quran_reader_screen.dart';

class SurahIndexScreen extends StatefulWidget {
  final List<SurahEntity> surahs;
  const SurahIndexScreen({super.key, required this.surahs});

  @override
  State<SurahIndexScreen> createState() => _SurahIndexScreenState();
}

class _SurahIndexScreenState extends State<SurahIndexScreen> {
  String _searchQuery = '';
  List<SurahEntity> get _filtered => widget.surahs
      .where(
        (s) =>
            s.nameEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.nameArabic.contains(_searchQuery) ||
            s.number.toString().contains(_searchQuery),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Surah Index'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by name or number...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final surah = _filtered[index];
                return _SurahTile(surah: surah);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahTile extends ConsumerWidget {
  final SurahEntity surah;
  const _SurahTile({required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryAccent,
                fontSize: 13,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.nameEnglish, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${surah.versesCount} verses',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: surah.revelationType == 'Meccan'
                              ? AppColors.warning.withValues(alpha: 0.15)
                              : AppColors.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          surah.revelationType,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: surah.revelationType == 'Meccan'
                                ? AppColors.warning
                                : AppColors.primaryAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surah.nameArabic,
                  style: AppTextStyles.arabicSmall.copyWith(fontSize: 18),
                  textDirection: TextDirection.rtl,
                ),
                Text('Juz ${surah.juzNumber}', style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
        onTap: () {
          ref.read(quranReaderProvider.notifier).goToPage(surah.startPage);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const QuranReaderScreen()),
          );
        },
      ),
    );
  }
}
