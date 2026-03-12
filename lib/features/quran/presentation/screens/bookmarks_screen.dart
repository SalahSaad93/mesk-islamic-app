import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_provider.dart';
import 'quran_reader_screen.dart';

class QuranBookmarksScreen extends ConsumerWidget {
  const QuranBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Bookmarks', style: AppTextStyles.cardTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: bookmarksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: AppColors.border,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryAccent.withValues(
                    alpha: 0.1,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: AppColors.primaryAccent,
                  ),
                ),
                title: Text(
                  bookmark.title ?? bookmark.surahName,
                  style: AppTextStyles.cardTitle,
                ),
                subtitle: Text(
                  'Ayah ${bookmark.ayahNumber} • ${_formatDate(bookmark.createdAt)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: () async {
                    await ref
                        .read(quranUserDataDatasourceProvider)
                        .deleteBookmark(bookmark.id);
                    ref.invalidate(bookmarksProvider);
                  },
                ),
                onTap: () {
                  // We need the page number to navigate...
                  // BookmarkEntity might need `page` field added, or we have to lookup it up.
                  // As a placeholder, we jump to page 1 for now
                  ref.read(quranReaderProvider.notifier).goToPage(1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuranReaderScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
