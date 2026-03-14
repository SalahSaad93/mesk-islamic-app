import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider must be overridden in ProviderScope');
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // === Settings ===
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool('isDarkMode', value);

  String get language => _prefs.getString('language') ?? 'ar';
  Future<void> setLanguage(String value) => _prefs.setString('language', value);

  String get calculationMethod => _prefs.getString('calculationMethod') ?? 'ISNA';
  Future<void> setCalculationMethod(String value) => _prefs.setString('calculationMethod', value);

  // === Tasbih ===
  String? getTasbihSessions() => _prefs.getString('tasbih_sessions');
  Future<void> saveTasbihSessions(String jsonString) => _prefs.setString('tasbih_sessions', jsonString);

  // === Quran ===
  int get lastReadPage => _prefs.getInt('quran_last_read_page') ?? 1;
  Future<void> setLastReadPage(int page) => _prefs.setInt('quran_last_read_page', page);

  String get selectedReciterId => _prefs.getString('quran_reciter_id') ?? 'ar.alafasy';
  Future<void> setSelectedReciterId(String id) => _prefs.setString('quran_reciter_id', id);

  String get readingMode => _prefs.getString('quran_reading_mode') ?? 'fullQuranMode';
  Future<void> setReadingMode(String mode) => _prefs.setString('quran_reading_mode', mode);

  // Khatma progress
  int get khatmaHighestPage => _prefs.getInt('khatma_highest_page') ?? 0;
  Future<void> setKhatmaHighestPage(int page) => _prefs.setInt('khatma_highest_page', page);

  String get khatmaStartDate => _prefs.getString('khatma_start_date') ?? DateTime.now().toIso8601String();
  Future<void> setKhatmaStartDate(String date) => _prefs.setString('khatma_start_date', date);

  bool get khatmaCompleted => _prefs.getBool('khatma_completed') ?? false;
  Future<void> setKhatmaCompleted(bool value) => _prefs.setBool('khatma_completed', value);

  Future<void> resetKhatma() async {
    await _prefs.setInt('khatma_highest_page', 0);
    await _prefs.setString('khatma_start_date', DateTime.now().toIso8601String());
    await _prefs.setBool('khatma_completed', false);
  }

  // Verse mode position
  int get verseModeSurah => _prefs.getInt('quran_verse_mode_surah') ?? 1;
  Future<void> setVerseModeSurah(int surah) => _prefs.setInt('quran_verse_mode_surah', surah);

  int get verseModeAyah => _prefs.getInt('quran_verse_mode_ayah') ?? 1;
  Future<void> setVerseModeAyah(int ayah) => _prefs.setInt('quran_verse_mode_ayah', ayah);

  // Reading preferences
  int get fontSize => _prefs.getInt('quran_font_size') ?? 2;
  Future<void> setFontSize(int size) => _prefs.setInt('quran_font_size', size);

  bool get nightMode => _prefs.getBool('quran_night_mode') ?? false;
  Future<void> setNightMode(bool enabled) => _prefs.setBool('quran_night_mode', enabled);

  bool get showTranslation => _prefs.getBool('quran_show_translation') ?? false;
  Future<void> setShowTranslation(bool show) => _prefs.setBool('quran_show_translation', show);

  // === Athkar ===
  String? getAthkarProgress(String category) => _prefs.getString('athkar_progress_$category');
  Future<void> saveAthkarProgress(String category, String jsonString) => _prefs.setString('athkar_progress_$category', jsonString);
  
  String? getAthkarLastReset(String category) => _prefs.getString('athkar_last_reset_$category');
  Future<void> setAthkarLastReset(String category, String dateString) => _prefs.setString('athkar_last_reset_$category', dateString);

  // === Notifications ===
  bool getPrayerNotification(String prayerName) => _prefs.getBool('notif_$prayerName') ?? true;
  Future<void> setPrayerNotification(String prayerName, bool value) => _prefs.setBool('notif_$prayerName', value);
}
