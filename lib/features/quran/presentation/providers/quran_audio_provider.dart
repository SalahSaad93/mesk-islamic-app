import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/reciter_entity.dart';
import '../../domain/entities/verse_entity.dart';
import '../../data/datasources/quran_audio_datasource.dart';
import './reciter_provider.dart';

final quranAudioDatasourceProvider = Provider((_) => QuranAudioDatasource());

class QuranAudioState {
  final bool isPlaying;
  final bool isDownloading;
  final int? currentPlayingVerseId;
  final ReciterEntity? selectedReciter;

  const QuranAudioState({
    this.isPlaying = false,
    this.isDownloading = false,
    this.currentPlayingVerseId,
    this.selectedReciter,
  });

  QuranAudioState copyWith({
    bool? isPlaying,
    bool? isDownloading,
    int? currentPlayingVerseId,
    ReciterEntity? selectedReciter,
  }) {
    return QuranAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isDownloading: isDownloading ?? this.isDownloading,
      currentPlayingVerseId:
          currentPlayingVerseId ?? this.currentPlayingVerseId,
      selectedReciter: selectedReciter ?? this.selectedReciter,
    );
  }
}

class QuranAudioNotifier extends StateNotifier<QuranAudioState> {
  final Ref _ref;
  final AudioPlayer _player;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _currentIndexSub;

  List<VerseEntity> _currentPlaylist = [];
  int _currentPlaylistIndex = -1;

  QuranAudioNotifier(this._ref)
      : _player = AudioPlayer(),
        super(const QuranAudioState()) {
    _init();
  }

  void _init() async {
    final storage = _ref.read(storageServiceProvider);
    final savedReciterId = storage.selectedReciterId;
    
    // Load reciters list
    final reciters = await _ref.read(recitersProvider.future);
    
    final r = reciters.firstWhere(
      (r) => r.id == savedReciterId,
      orElse: () => reciters.first,
    );
    state = state.copyWith(selectedReciter: r);

    _playerStateSub = _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      bool isDownloading = false;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        isDownloading = true;
      }

      state = state.copyWith(
        isPlaying: isPlaying && processingState != ProcessingState.completed,
        isDownloading: isDownloading,
      );

      if (processingState == ProcessingState.completed) {
        _nextVerse();
      }
    });
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _currentIndexSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void changeReciter(ReciterEntity reciter) {
    _ref.read(storageServiceProvider).setSelectedReciterId(reciter.id);
    state = state.copyWith(selectedReciter: reciter);
    // If playing, we might want to restart current verse, but handled automatically on next play.
  }

  Future<void> playVerseList(List<VerseEntity> verses, int startIndex) async {
    if (verses.isEmpty || startIndex < 0 || startIndex >= verses.length) return;
    _currentPlaylist = verses;
    _currentPlaylistIndex = startIndex;
    await _playCurrentIndex();
  }

  Future<void> _playCurrentIndex() async {
    if (_currentPlaylist.isEmpty ||
        _currentPlaylistIndex < 0 ||
        _currentPlaylistIndex >= _currentPlaylist.length) {
      _stop();
      return;
    }
    final verse = _currentPlaylist[_currentPlaylistIndex];
    state = state.copyWith(
      currentPlayingVerseId: verse.id,
      isDownloading: true,
    );

    final reciter = state.selectedReciter;
    if (reciter == null) {
      _stop();
      return;
    }

    final ds = _ref.read(quranAudioDatasourceProvider);
    final url = ds.getVerseAudioUrl(
      reciter.audioBaseUrl,
      verse.surahNumber,
      verse.ayahNumber,
    );

    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      // Audio load error, skip or stop
      state = state.copyWith(
        isDownloading: false,
        currentPlayingVerseId: null,
        isPlaying: false,
      );
    }
  }

  Future<void> _nextVerse() async {
    final nextIndex = _currentPlaylistIndex + 1;
    if (nextIndex < _currentPlaylist.length) {
      _currentPlaylistIndex = nextIndex;
      await _playCurrentIndex();
    } else {
      _stop();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    if (_currentPlaylist.isNotEmpty) {
      if (state.currentPlayingVerseId != null) {
        await _player.play();
      } else {
        await _playCurrentIndex();
      }
    }
  }

  void _stop() {
    _player.stop();
    state = state.copyWith(
      isPlaying: false,
      currentPlayingVerseId: null,
      isDownloading: false,
    );
  }

  Future<void> stop() async {
    _stop();
  }
}

final quranAudioProvider =
    StateNotifierProvider<QuranAudioNotifier, QuranAudioState>((ref) {
      return QuranAudioNotifier(ref);
    });
