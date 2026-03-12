import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/verse_entity.dart';
import '../providers/user_data_provider.dart';

class VerseActionsMenu extends ConsumerWidget {
  final VerseEntity verse;
  final VoidCallback onPlay;
  final VoidCallback onBookmark;
  final VoidCallback onHighlight;
  final VoidCallback onAddNote;
  final VoidCallback onShare;
  final VoidCallback onTafsir;

  const VerseActionsMenu({
    super.key,
    required this.verse,
    required this.onPlay,
    required this.onBookmark,
    required this.onHighlight,
    required this.onAddNote,
    required this.onShare,
    required this.onTafsir,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final highlightsAsync = ref.watch(highlightsProvider);
    final notesAsync = ref.watch(notesProvider);

    final isBookmarked = bookmarksAsync.when(
      data: (list) => list.any((b) => b.verseId == verse.id),
      loading: () => false,
      error: (_, __) => false,
    );

    final isHighlighted = highlightsAsync.when(
      data: (list) => list.any((h) => h.verseId == verse.id),
      loading: () => false,
      error: (_, __) => false,
    );

    final hasNote = notesAsync.when(
      data: (list) => list.any((n) => n.verseId == verse.id),
      loading: () => false,
      error: (_, __) => false,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(Icons.play_arrow_rounded, 'Play', onPlay),
          _buildActionButton(
            isBookmarked ? Icons.bookmark : Icons.bookmark_outline_rounded,
            'Bookmark',
            onBookmark,
            isActive: isBookmarked,
          ),
          _buildActionButton(
            isHighlighted ? Icons.highlight_rounded : Icons.highlight_outlined,
            'Highlight',
            onHighlight,
            isActive: isHighlighted,
          ),
          _buildActionButton(
            hasNote ? Icons.note_alt : Icons.note_add_rounded,
            'Note',
            onAddNote,
            isActive: hasNote,
          ),
          _buildActionButton(Icons.share_rounded, 'Share', onShare),
          _buildActionButton(Icons.menu_book_rounded, 'Tafsir', onTafsir),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.warning
                    : AppColors.primaryAccent,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: isActive
                      ? AppColors.warning
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
