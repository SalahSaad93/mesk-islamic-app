import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/verse_entity.dart';
import '../providers/quran_provider.dart';
import '../providers/quran_khatma_provider.dart';
import '../providers/quran_preferences_provider.dart';
import '../providers/quran_audio_provider.dart';
import '../widgets/verse_mode_card.dart';
import '../widgets/reader_settings_sheet.dart';

class QuranVerseModeScreen extends ConsumerStatefulWidget {
  final int initialSurah;
  final int initialAyah;

  const QuranVerseModeScreen({
    super.key,
    this.initialSurah = 1,
    this.initialAyah = 1,
  });

  @override
  ConsumerState<QuranVerseModeScreen> createState() => _QuranVerseModeScreenState();
}

class _QuranVerseModeScreenState extends ConsumerState<QuranVerseModeScreen> {
  late int _surahNumber;
  late int _ayahNumber;
  late PageController _pageController;
  late int _currentIndex;
  bool _isAudioInitialized = false;

  @override
  void initState() {
    super.initState();
    _surahNumber = widget.initialSurah;
    _ayahNumber = widget.initialAyah;
    _currentIndex = (_surahNumber - 1) * 100 + (_ayahNumber - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    final audioNotifier = ref.read(quranAudioProvider.notifier);
    await audioNotifier.playVerseList(
      [VerseEntity(
        id: _currentIndex + 1,
        surahNumber: _surahNumber,
        ayahNumber: _ayahNumber,
        textUthmani: '',
        textSimple: '',
        page: 1,
        juz: 1,
        hizb: 1,
      )],
      0,
    );
    setState(() {
      _isAudioInitialized = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    ref.read(quranAudioProvider.notifier).stop();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final previousIndex = _currentIndex;
    
    if (index < 0 || index >= 6236) return;
    
    final previousSurah = previousIndex ~/ 100 + 1;
    final previousAyah = (previousIndex % 100) + 1;
    final newSurah = index ~/ 100 + 1;
    final newAyah = (index % 100) + 1;
    
    if (previousSurah == 1 && previousAyah == 1 && newSurah == 1 && newAyah == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beginning of Quran'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    
    if (newSurah == 114 && newAyah == 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('End of Quran - Khatma Complete!'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Start New',
            onPressed: () {
              ref.read(khatmaProvider.notifier).resetKhatma();
            },
          ),
        ),
      );
    }

    setState(() {
      _currentIndex = index;
      _surahNumber = newSurah;
      _ayahNumber = newAyah;
    });

    ref.read(storageServiceProvider).setVerseModeSurah(_surahNumber);
    ref.read(storageServiceProvider).setVerseModeAyah(_ayahNumber);

    if (_isAudioInitialized) {
      final audioNotifier = ref.read(quranAudioProvider.notifier);
      final newVerse = VerseEntity(
        id: index + 1,
        surahNumber: _surahNumber,
        ayahNumber: _ayahNumber,
        textUthmani: '',
        textSimple: '',
        page: 1,
        juz: 1,
        hizb: 1,
      );
      audioNotifier.stop();
      audioNotifier.playVerseList([newVerse], 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(quranAudioProvider);
    final isPlaying = audioState.isPlaying;
    final preferences = ref.watch(quranPreferencesProvider);
    
    final backgroundColor = preferences.nightMode 
        ? const Color(0xFF121212) 
        : AppColors.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
            child: PageView.builder(
              controller: _pageController,
              itemCount: 6236,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return VerseModeCard(
                  verse: VerseEntity(
                    id: index + 1,
                    surahNumber: index ~/ 100 + 1,
                    ayahNumber: (index % 100) + 1,
                    textUthmani: '',
                    textSimple: '',
                    page: 1,
                    juz: 1,
                    hizb: 1,
                  ),
                );
              },
            ),
          ),

          // Top bar
          Positioned(
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Surah $_surahNumber',
                          style: AppTextStyles.cardTitle,
                        ),
                        Text(
                          'Ayah $_ayahNumber',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.translate),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Translation toggle coming soon!')),
                      );
                    },
                    tooltip: 'Toggle Translation',
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => showReaderSettingsSheet(context),
                    tooltip: 'Reader Settings',
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
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
                    IconButton(
                      icon: const Icon(Icons.skip_previous_outlined),
                      onPressed: _currentIndex > 0
                          ? () => _pageController.animateToPage(
                                _currentIndex - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : null,
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await ref.read(quranAudioProvider.notifier).pause();
                          } else {
                            await ref.read(quranAudioProvider.notifier).resume();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_outlined),
                      onPressed: _currentIndex < 6235
                          ? () => _pageController.animateToPage(
                                _currentIndex + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
