import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/storage_service.dart';
import '../../domain/entities/reading_preferences_entity.dart';

class QuranPreferencesProvider extends StateNotifier<ReadingPreferencesEntity> {
  final StorageService _storageService;

  QuranPreferencesProvider(this._storageService)
    : super(ReadingPreferencesEntity()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReadingPreferencesEntity.fromMap({
      'font_size': prefs.getInt('quran_font_size') ?? 2,
      'night_mode': prefs.getBool('quran_night_mode') ?? false,
      'show_translation': prefs.getBool('quran_show_translation') ?? false,
    });
  }

  Future<void> setFontSize(int level) async {
    state = state.copyWith(fontSize: level);
    await _storageService.setFontSize(level);
  }

  Future<void> toggleNightMode() async {
    state = state.copyWith(nightMode: !state.nightMode);
    await _storageService.setNightMode(state.nightMode);
  }

  Future<void> setShowTranslation(bool show) async {
    state = state.copyWith(showTranslation: show);
    await _storageService.setShowTranslation(show);
  }
}

final quranPreferencesProvider =
    StateNotifierProvider<QuranPreferencesProvider, ReadingPreferencesEntity>((
      ref,
    ) {
      final storageService = ref.watch(storageServiceProvider);
      return QuranPreferencesProvider(storageService);
    });
