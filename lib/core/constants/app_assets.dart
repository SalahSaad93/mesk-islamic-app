class AppAssets {
  AppAssets._(); // Prevent instantiation

  // Directories
  static const String dataDir = 'assets/data/';
  static const String imagesDir = 'assets/images/';
  static const String soundsDir = 'assets/sounds/';

  // Images
  static const String splashLogo = '${imagesDir}splash_logo.png';
  static const String quranKareemLogo = '${imagesDir}quran_kareem.png';
  static const String defaultBackground = '${imagesDir}default_bg.png';

  // Data
  static const String dailyVersesData = '${dataDir}daily_verses.json';
  static const String athkarMorning = '${dataDir}athkar_morning.json';
  static const String athkarEvening = '${dataDir}athkar_evening.json';
  static const String athkarAfterFajr = '${dataDir}athkar_after_fajr.json';
  static const String athkarSleep = '${dataDir}athkar_sleep.json';
  static const String athkarAyatKursi = '${dataDir}athkar_ayat_kursi.json';
  static const String athkarIstighfar = '${dataDir}athkar_istighfar.json';
  static const String athkarTasbih = '${dataDir}athkar_tasbih.json';
  static const String athkarAfterMaghrib = '${dataDir}athkar_after_maghrib.json';

  // Sounds
  static const String notificationSound = '${soundsDir}notification.mp3';
}
