// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Islamic Companion';

  @override
  String get homeTab => 'Home';

  @override
  String get prayersTab => 'Prayers';

  @override
  String get qiblaTab => 'Qibla';

  @override
  String get quranTab => 'Quran';

  @override
  String get athkarTab => 'Athkar';

  @override
  String get moreTab => 'More';

  @override
  String get tasbihTab => 'Tasbih';

  @override
  String get assalamuAlaikum => 'Assalamu Alaikum';

  @override
  String get currentPrayer => 'Current Prayer';

  @override
  String get next => 'Next:';

  @override
  String get remaining => 'remaining';

  @override
  String get upcomingPrayers => 'Upcoming Prayers';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get qiblaDirection => 'Qibla Direction';

  @override
  String get holyBook => 'Holy book';

  @override
  String get supplications => 'Supplications';

  @override
  String get dailyInspiration => 'Daily Inspiration';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get calculationMethod => 'Calculation Method';

  @override
  String usingMethodForCalculations(String method) {
    return 'Using $method method for prayer time calculations.';
  }

  @override
  String get changeSettings => 'Change settings';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get dawnPrayer => 'Dawn Prayer';

  @override
  String get noonPrayer => 'Noon Prayer';

  @override
  String get afternoonPrayer => 'Afternoon Prayer';

  @override
  String get sunsetPrayer => 'Sunset Prayer';

  @override
  String get nightPrayer => 'Night Prayer';

  @override
  String get settingsAndPreferences => 'Settings and preferences';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get appLanguage => 'App Language';

  @override
  String get sunnanQuranieh => 'Sunnan Quranieh';

  @override
  String get recommendedSurahs => 'Recommended Surahs';

  @override
  String get suratAlKahf => 'Surat Al-Kahf';

  @override
  String get suratAlKahfDesc => 'Recite every Friday';

  @override
  String get suratAlKahfProt => '✨ Protection from Dajjal';

  @override
  String get beforeSleep => 'Before Sleep';

  @override
  String get beforeSleepDesc => 'Recite before sleep';

  @override
  String get beforeSleepProt => '✨ Protection in the grave';

  @override
  String get suratAlBaqarah => 'Surat Al-Baqarah';

  @override
  String get suratAlBaqarahDesc => 'The longest chapter';

  @override
  String get suratAlBaqarahProt => '✨ Barakah and protection';

  @override
  String get islamicReminders => 'Islamic Reminders';

  @override
  String get morningDhikr => 'Morning Dhikr';

  @override
  String get morningDhikrDesc => 'Daily morning remembrance';

  @override
  String get eveningDhikr => 'Evening Dhikr';

  @override
  String get eveningDhikrDesc => 'Daily evening remembrance';

  @override
  String get suratAlMulk => 'Surat Al-Mulk';

  @override
  String get suratAlMulkDesc => 'Before sleep protection';

  @override
  String get suratAlBaqarahReminder => 'Surat Al-Baqarah';

  @override
  String get suratAlBaqarahReminderDesc => 'Weekly recitation';

  @override
  String get appSettings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get audioSettings => 'Audio Settings';

  @override
  String get downloadQuran => 'Download Quran';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get accountAndData => 'Account & Data';

  @override
  String get profile => 'Profile';

  @override
  String get favorites => 'Favorites';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get readingProgress => 'Reading Progress';

  @override
  String get support => 'Support';

  @override
  String get helpAndFaq => 'Help & FAQ';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get shareApp => 'Share App';

  @override
  String get rateApp => 'Rate App';

  @override
  String version(String number) {
    return 'Version $number';
  }

  @override
  String get madeWithLove => 'Made with ❤ for the Muslim Ummah';

  @override
  String get privacyProtected => 'Privacy Protected';

  @override
  String get locationPermissionTitle => 'Location Access';

  @override
  String get locationPermissionRationale =>
      'We need your location to calculate accurate prayer times and determine the Qibla direction for your current area.';

  @override
  String get allow => 'Allow';

  @override
  String get cancel => 'Cancel';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission is permanently denied. Please enable it in your device settings to use this feature.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get retry => 'Retry';

  @override
  String get couldNotLoadPrayerTimes => 'Could not load prayer times';

  @override
  String get enableLocationForPrayerTimes => 'Enable location for prayer times';

  @override
  String get todaysPrayers => 'Today\'s Prayers';

  @override
  String get failedToLoadQibla => 'Failed to load Qibla Data';

  @override
  String get ensurePermissions =>
      'Please ensure location & compass permissions are granted.';

  @override
  String get alignArrowToKaaba =>
      'Align the arrow with the top to face the Kaaba';

  @override
  String qiblaDegrees(Object degrees) {
    return 'Qibla: $degrees°';
  }
}
