import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_provider.dart';
import '../providers/quran_audio_provider.dart';
import 'verse_widget.dart';
import 'tafsir_bottom_sheet.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../providers/user_data_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:confetti/confetti.dart';

class MushafPageView extends ConsumerStatefulWidget {
  final int pageNumber;
  final bool showTranslation;

  const MushafPageView({
    super.key,
    required this.pageNumber,
    this.showTranslation = true,
  });

  @override
  ConsumerState<MushafPageView> createState() => _MushafPageViewState();
}

class _MushafPageViewState extends ConsumerState<MushafPageView> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _scrollToVerseIndex(int index) {
    if (_scrollController.isAttached) {
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final versesAsync = ref.watch(versesForPageProvider(widget.pageNumber));
    final audioState = ref.watch(quranAudioProvider);
    final highlightsAsync = ref.watch(
      highlightsForPageProvider(widget.pageNumber),
    );

    return Stack(
      children: [
        versesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, st) => Center(
            child: Text('Error loading page ${widget.pageNumber}:\n$e'),
          ),
          data: (verses) {
            if (verses.isEmpty) {
              return const Center(
                child: Text('No verses found for this page.'),
              );
            }

            // Optional: auto-scroll to current playing verse if it's on this page
            final playingId = audioState.currentPlayingVerseId;
            if (playingId != null) {
              final idx = verses.indexWhere((v) => v.id == playingId);
              if (idx != -1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToVerseIndex(idx);
                });
              }
            }

            final highlightsMap = highlightsAsync.valueOrNull ?? {};

            return Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Surah ${verses.first.surahNumber}',
                        style: AppTextStyles.labelSmall,
                      ),
                      Text(
                        'Juz ${verses.first.juz}',
                        style: AppTextStyles.labelSmall,
                      ),
                      Text(
                        'Page ${widget.pageNumber}',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border),
                Expanded(
                  child: ScrollablePositionedList.builder(
                    itemCount: verses.length,
                    itemScrollController: _scrollController,
                    itemPositionsListener: _itemPositionsListener,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      final isPlaying =
                          audioState.currentPlayingVerseId == verse.id;
                      final highlight = highlightsMap[verse.id];

                      return Column(
                        children: [
                          if (index == 0 && verse.ayahNumber == 1)
                            _buildSurahHeader(verse.surahNumber),
                          if (index > 0 &&
                              verse.surahNumber !=
                                  verses[index - 1].surahNumber)
                            _buildSurahHeader(verse.surahNumber),
                          VerseWidget(
                            verse: verse,
                            isPlaying: isPlaying,
                            isHighlighted: highlight != null,
                            highlightColor: highlight?.color,
                            showTranslation: widget.showTranslation,
                            onPlay: (v) {
                              final startIndex = verses.indexWhere(
                                (vh) => vh.id == v.id,
                              );
                              ref
                                  .read(quranAudioProvider.notifier)
                                  .playVerseList(verses, startIndex);
                            },
                            onBookmark: (v) async {
                              final bookmarks =
                                  ref.read(bookmarksProvider).valueOrNull ?? [];
                              final isFirst = bookmarks.isEmpty;

                              final bookmark = BookmarkEntity(
                                id: 'b_${v.id}',
                                verseId: v.id,
                                surahNumber: v.surahNumber,
                                ayahNumber: v.ayahNumber,
                                surahName: 'Surah ${v.surahNumber}',
                                createdAt: DateTime.now(),
                              );
                              await ref
                                  .read(bookmarksProvider.notifier)
                                  .toggleBookmark(bookmark);
                              if (context.mounted) {
                                if (isFirst) _confettiController.play();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Bookmark toggled'),
                                  ),
                                );
                              }
                            },
                            onHighlight: (v) async {
                              final highlights =
                                  ref.read(highlightsProvider).valueOrNull ??
                                  [];
                              final isFirst = highlights.isEmpty;

                              final highlight = HighlightEntity(
                                id: 'h_${v.id}',
                                verseId: v.id,
                                surahNumber: v.surahNumber,
                                ayahNumber: v.ayahNumber,
                                color: '#FFEA00',
                                createdAt: DateTime.now(),
                              );
                              await ref
                                  .read(highlightsProvider.notifier)
                                  .addHighlight(highlight);
                              if (context.mounted) {
                                if (isFirst) _confettiController.play();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Highlight added'),
                                  ),
                                );
                              }
                            },
                            onAddNote: (v) {
                              _showNoteDialog(context, ref, v);
                            },
                            onShare: (v) {
                              final surah = ref.read(
                                surahByNumberProvider(v.surahNumber),
                              );
                              final surahName =
                                  surah?.nameEnglish ??
                                  'Surah ${v.surahNumber}';
                              Share.share(
                                '${v.textUthmani} ($surahName:${v.ayahNumber})\n'
                                '${v.textSimple}\n\n'
                                'Shared via Mesk Islamic App',
                              );
                            },
                            onTafsir: (v) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => DraggableScrollableSheet(
                                  initialChildSize: 0.6,
                                  minChildSize: 0.4,
                                  maxChildSize: 0.9,
                                  builder: (_, scrollCtrl) => TafsirBottomSheet(
                                    surahNumber: v.surahNumber,
                                    ayahNumber: v.ayahNumber,
                                    textUthmani: v.textUthmani,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppColors.primaryAccent,
              AppColors.warning,
              Colors.blue,
              Colors.pink,
              Colors.orange,
            ],
          ),
        ),
      ],
    );
  }

  void _showNoteDialog(BuildContext context, WidgetRef ref, verse) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note for ${verse.surahNumber}:${verse.ayahNumber}'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 2000,
          decoration: const InputDecoration(
            hintText: 'Your reflection...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final notes = ref.read(notesProvider).valueOrNull ?? [];
              final isFirst = notes.isEmpty;

              final note = NoteEntity(
                id: 'n_${verse.id}_${DateTime.now().millisecondsSinceEpoch}',
                verseId: verse.id,
                surahNumber: verse.surahNumber,
                ayahNumber: verse.ayahNumber,
                surahName: 'Surah ${verse.surahNumber}',
                text: controller.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await ref.read(notesProvider.notifier).saveNote(note);
              if (context.mounted) {
                Navigator.pop(context);
                if (isFirst) _confettiController.play();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Note saved')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeader(int surahNum) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        image: const DecorationImage(
          image: AssetImage('assets/images/header_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.05,
        ),
      ),
      child: Center(
        child: Text(
          'سورة $surahNum', // Real title needed from DB
          style: AppTextStyles.arabicLarge.copyWith(
            color: AppColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
