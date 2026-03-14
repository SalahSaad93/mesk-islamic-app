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

  String get readingMode => _prefs.getString('quran_reading_mode') ?? 'mushafPage';
  Future<void> setReadingMode(String mode) => _prefs.setString('quran_reading_mode', mode);

  // === Athkar ===
  String? getAthkarProgress(String category) => _prefs.getString('athkar_progress_$category');
  Future<void> saveAthkarProgress(String category, String jsonString) => _prefs.setString('athkar_progress_$category', jsonString);
  
  String? getAthkarLastReset(String category) => _prefs.getString('athkar_last_reset_$category');
  Future<void> setAthkarLastReset(String category, String dateString) => _prefs.setString('athkar_last_reset_$category', dateString);

  // === Notifications ===
  bool getPrayerNotification(String prayerName) => _prefs.getBool('notif_$prayerName') ?? true;
  Future<void> setPrayerNotification(String prayerName, bool value) => _prefs.setBool('notif_$prayerName', value);
}
