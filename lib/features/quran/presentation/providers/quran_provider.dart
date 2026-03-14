import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_local_datasource.dart';
import '../../data/datasources/quran_db_datasource.dart';
import '../../data/datasources/quran_user_data_datasource.dart';
import '../../data/services/quran_database_service.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/entities/verse_position_entity.dart';
import '../../../../core/services/storage_service.dart';
export 'user_data_provider.dart';
export 'quran_repository_provider.dart';


// ===== Datasource providers =====

final quranDatasourceProvider = Provider((_) => QuranLocalDatasource());

final quranDbDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(quranDbServiceProvider);
  return QuranDbDatasource(dbService);
});

final quranUserDataDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(quranDbServiceProvider);
  return QuranUserDataDatasource(dbService);
});

// ===== Core data providers =====

final surahsProvider = FutureProvider<List<SurahEntity>>((ref) async {
  return ref.read(quranDatasourceProvider).getSurahs();
});

final surahByNumberProvider = Provider.family<SurahEntity?, int>((ref, number) {
  final surahs = ref.watch(surahsProvider).valueOrNull ?? [];
  try {
    return surahs.firstWhere((s) => s.number == number);
  } catch (_) {
    return null;
  }
});

final versesForPageProvider = FutureProvider.family<List<VerseEntity>, int>((
  ref,
  page,
) async {
  return ref.read(quranDbDatasourceProvider).getVersesForPage(page);
});

final versesForSurahProvider = FutureProvider.family<List<VerseEntity>, int>((
  ref,
  surahNumber,
) async {
  return ref.read(quranDbDatasourceProvider).getVersesForSurah(surahNumber);
});

final allJuzProvider = FutureProvider<List<JuzEntity>>((ref) async {
  return ref.read(quranDbDatasourceProvider).getAllJuz();
});

final verseCountProvider = FutureProvider<int>((ref) async {
  return ref.read(quranDbDatasourceProvider).getVerseCount();
});

// ===== Search =====

final quranSearchQueryProvider = StateProvider<String>((ref) => '');

final quranSearchResultsProvider = FutureProvider<List<VerseEntity>>((
  ref,
) async {
  final query = ref.watch(quranSearchQueryProvider);
  if (query.trim().isEmpty) return [];
  return ref.read(quranDbDatasourceProvider).searchVerses(query);
});

// ===== User data providers =====

// User data providers are now in user_data_provider.dart


// ===== Reader state =====

final currentPageProvider = StateProvider<int>((ref) => 1);
final currentSurahProvider = StateProvider<SurahEntity?>((ref) => null);
final isAudioPlayingProvider = StateProvider<bool>((ref) => false);
final readingModeProvider = StateProvider<String>((ref) => 'fullQuranMode');

class QuranReaderState {
  final int currentPage;
  final int totalPages;
  final bool isOverlayVisible;
  final String readingMode;

  const QuranReaderState({
    this.currentPage = 1,
    this.totalPages = 604,
    this.isOverlayVisible = true,
    this.readingMode = 'fullQuranMode',
  });

  QuranReaderState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isOverlayVisible,
    String? readingMode,
  }) {
    return QuranReaderState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      readingMode: readingMode ?? this.readingMode,
    );
  }
}

class QuranReaderNotifier extends StateNotifier<QuranReaderState> {
  final StorageService _storageService;

  QuranReaderNotifier(this._storageService)
      : super(const QuranReaderState()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final lastPage = _storageService.lastReadPage;
    state = state.copyWith(currentPage: lastPage);
  }

  void goToPage(int page) {
    final newPage = page.clamp(1, 604);
    state = state.copyWith(currentPage: newPage);
    _storageService.setLastReadPage(newPage);
  }

  void toggleOverlay() {
    state = state.copyWith(isOverlayVisible: !state.isOverlayVisible);
  }

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
    _storageService.setLastReadPage(page);
  }

  void setReadingMode(String mode) {
    state = state.copyWith(readingMode: mode);
    _storageService.setReadingMode(mode);
  }
}

final quranReaderProvider =
    StateNotifierProvider<QuranReaderNotifier, QuranReaderState>((ref) {
      final storageService = ref.watch(storageServiceProvider);
      return QuranReaderNotifier(storageService);
    });
