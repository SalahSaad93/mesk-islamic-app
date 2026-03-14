import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_provider.dart';
import 'quran_reader_screen.dart';

class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(quranSearchQueryProvider.notifier).state = query.trim();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(quranSearchResultsProvider);
    final query = ref.watch(quranSearchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          onChanged: _onSearch,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search verses (Arabic only for now)...',
            border: InputBorder.none,
            hintStyle:
                const TextStyle(color: AppColors.textTertiary, fontSize: 16),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon:
                        const Icon(Icons.clear, color: AppColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                  )
                : null,
          ),
          style: AppTextStyles.bodyLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: _buildBody(query, searchResults),
    );
  }

  Widget _buildBody(String query, AsyncValue searchResults) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.border),
            const SizedBox(height: 16),
            Text(
              'Search the Quran',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return searchResults.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAccent),
      ),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              'No results found for "$query"',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.border),
          itemBuilder: (context, index) {
            final verse = results[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                '${verse.textUthmani} ﴿${verse.ayahNumber}﴾',
                style: AppTextStyles.arabicLarge.copyWith(height: 1.8),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Surah ${verse.surahNumber}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Page ${verse.page}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Navigate to the reader screen at the specific page
                ref.read(quranReaderProvider.notifier).goToPage(verse.page);
                // In a real app we might automatically highlight the search result
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const QuranReaderScreen()),
                );
              },
            );
          },
        );
      },
    );
  }
}
