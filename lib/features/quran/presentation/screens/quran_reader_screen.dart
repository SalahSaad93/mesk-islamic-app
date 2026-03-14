import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/storage_service.dart';
import '../providers/quran_audio_provider.dart';
import '../providers/quran_provider.dart';
import '../providers/quran_khatma_provider.dart';
import '../widgets/mushaf_page_view.dart';
import '../widgets/reciter_picker_sheet.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/khatma_progress_widget.dart';

class QuranReaderScreen extends ConsumerStatefulWidget {
  const QuranReaderScreen({super.key});

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final readerState = ref.read(quranReaderProvider);
    _pageController = PageController(initialPage: readerState.currentPage - 1);
    // Hide status bar and bottom navigation for immersive reading
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int index) {
    final page = index + 1;
    ref.read(quranReaderProvider.notifier).onPageChanged(page);
    // Update khatma progress
    ref.read(khatmaProvider.notifier).onPageRead(page);
  }

  @override
  Widget build(BuildContext context) {
    final readerState = ref.watch(quranReaderProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => ref.read(quranReaderProvider.notifier).toggleOverlay(),
            child: PageView.builder(
              controller: _pageController,
              reverse: false, // RTL handled by math (604 - index)
              itemCount: 604,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final page = 604 - index;
                return MushafPageView(pageNumber: page);
              },
            ),
          ),

          if (readerState.isOverlayVisible) ...[
            _buildTopOverlay(context, readerState),
            _buildBottomOverlay(context, readerState),
          ],
        ],
      ),
    );
  }

  Widget _buildTopOverlay(BuildContext context, QuranReaderState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            Text('Page ${state.currentPage}', style: AppTextStyles.cardTitle),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: _showSettingsSheet,
            ),
            KhatmaProgressWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomOverlay(BuildContext context, QuranReaderState state) {
    final audioState = ref.watch(quranAudioProvider);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomAction(
                icon: Icons.bookmark_outline,
                label: 'Bookmark',
                onTap: () {
                  // TODO: Save page bookmark
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Page ${state.currentPage} bookmarked!'),
                    ),
                  );
                },
              ),
              _buildBottomAction(
                icon: audioState.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                label: audioState.isPlaying ? 'Pause' : 'Play Page',
                isPrimary: true,
                onTap: () {
                  if (audioState.isPlaying) {
                    ref.read(quranAudioProvider.notifier).pause();
                  } else {
                    if (audioState.currentPlayingVerseId != null) {
                      ref.read(quranAudioProvider.notifier).resume();
                    } else {
                      // By default, start playing all verses on the active page
                      final verses =
                          ref
                              .read(versesForPageProvider(state.currentPage))
                              .valueOrNull ??
                          [];
                      ref
                          .read(quranAudioProvider.notifier)
                          .playVerseList(verses, 0);
                    }
                  }
                },
                isLoading: audioState.isDownloading,
              ),
              _buildBottomAction(
                icon: Icons.list_alt,
                label: 'Index',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryAccent,
                ),
              )
            else
              Icon(
                icon,
                color: isPrimary
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
                size: isPrimary ? 32 : 24,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isPrimary
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
                fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet() {
    showReaderSettingsSheet(context);
  }
}
