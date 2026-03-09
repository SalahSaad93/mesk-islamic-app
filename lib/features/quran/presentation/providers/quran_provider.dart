import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_local_datasource.dart';
import '../../domain/entities/surah_entity.dart';

final quranDatasourceProvider = Provider((_) => QuranLocalDatasource());

final surahsProvider = FutureProvider<List<SurahEntity>>((ref) async {
  return ref.read(quranDatasourceProvider).getSurahs();
});

final currentPageProvider = StateProvider<int>((ref) => 1);
final currentSurahProvider = StateProvider<SurahEntity?>((ref) => null);
final isAudioPlayingProvider = StateProvider<bool>((ref) => false);

class QuranReaderState {
  final int currentPage;
  final int totalPages;
  final bool isOverlayVisible;

  const QuranReaderState({
    this.currentPage = 1,
    this.totalPages = 604,
    this.isOverlayVisible = true,
  });

  QuranReaderState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isOverlayVisible,
  }) {
    return QuranReaderState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
    );
  }
}

class QuranReaderNotifier extends StateNotifier<QuranReaderState> {
  QuranReaderNotifier() : super(const QuranReaderState());

  void goToPage(int page) {
    state = state.copyWith(currentPage: page.clamp(1, 604));
  }

  void toggleOverlay() {
    state = state.copyWith(isOverlayVisible: !state.isOverlayVisible);
  }

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }
}

final quranReaderProvider =
    StateNotifierProvider<QuranReaderNotifier, QuranReaderState>(
  (_) => QuranReaderNotifier(),
);
