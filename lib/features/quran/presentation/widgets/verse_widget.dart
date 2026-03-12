import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/verse_entity.dart';
import 'verse_actions_menu.dart';

class VerseWidget extends StatefulWidget {
  final VerseEntity verse;
  final bool isPlaying;
  final bool isHighlighted;
  final String? highlightColor;
  final bool showTranslation;
  final Function(VerseEntity) onPlay;
  final Function(VerseEntity) onBookmark;
  final Function(VerseEntity) onHighlight;
  final Function(VerseEntity) onAddNote;
  final Function(VerseEntity) onShare;
  final Function(VerseEntity) onTafsir;

  const VerseWidget({
    super.key,
    required this.verse,
    this.isPlaying = false,
    this.isHighlighted = false,
    this.highlightColor,
    this.showTranslation = true,
    required this.onPlay,
    required this.onBookmark,
    required this.onHighlight,
    required this.onAddNote,
    required this.onShare,
    required this.onTafsir,
  });

  @override
  State<VerseWidget> createState() => _VerseWidgetState();
}

class _VerseWidgetState extends State<VerseWidget> {
  bool _isExpanded = false;

  void _toggleActions() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    if (widget.isPlaying) {
      bg = AppColors.primaryAccent.withValues(alpha: 0.15);
    } else if (widget.isHighlighted && widget.highlightColor != null) {
      // Very basic color parsing for '#FFFF00' format
      try {
        bg = Color(
          int.parse(widget.highlightColor!.substring(1), radix: 16) +
              0xFF000000,
        ).withValues(alpha: 0.2);
      } catch (_) {}
    }

    return InkWell(
      onTap: _toggleActions,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: bg,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Surah:Ayah and actions button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${widget.verse.surahNumber}:${widget.verse.ayahNumber}',
                    style: AppTextStyles.labelSmall,
                  ),
                ),
                if (widget.isPlaying)
                  const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryAccent,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Arabic text
            Text(
              '${widget.verse.textUthmani} ﴿${widget.verse.ayahNumber}﴾',
              style: AppTextStyles.arabicLarge.copyWith(height: 1.8),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),

            // Translation
            if (widget.showTranslation) ...[
              const SizedBox(height: 16),
              Text(
                widget
                    .verse
                    .textSimple, // Here we use textSimple as a placeholder for translation, as real translation isn't in DB yet
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.left,
              ),
            ],

            // Action Menu
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 8),
              VerseActionsMenu(
                verse: widget.verse,
                onPlay: () => widget.onPlay(widget.verse),
                onBookmark: () => widget.onBookmark(widget.verse),
                onHighlight: () => widget.onHighlight(widget.verse),
                onAddNote: () => widget.onAddNote(widget.verse),
                onShare: () => widget.onShare(widget.verse),
                onTafsir: () => widget.onTafsir(widget.verse),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
