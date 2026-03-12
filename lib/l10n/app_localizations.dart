import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Companion'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @prayersTab.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get prayersTab;

  /// No description provided for @qiblaTab.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaTab;

  /// No description provided for @quranTab.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quranTab;

  /// No description provided for @athkarTab.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get athkarTab;

  /// No description provided for @moreTab.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTab;

  /// No description provided for @tasbihTab.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbihTab;

  /// No description provided for @assalamuAlaikum.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get assalamuAlaikum;

  /// No description provided for @currentPrayer.
  ///
  /// In en, this message translates to:
  /// **'Current Prayer'**
  String get currentPrayer;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next:'**
  String get next;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @upcomingPrayers.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Prayers'**
  String get upcomingPrayers;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaDirection;

  /// No description provided for @holyBook.
  ///
  /// In en, this message translates to:
  /// **'Holy book'**
  String get holyBook;

  /// No description provided for @supplications.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get supplications;

  /// No description provided for @dailyInspiration.
  ///
  /// In en, this message translates to:
  /// **'Daily Inspiration'**
  String get dailyInspiration;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethod;

  /// No description provided for @usingMethodForCalculations.
  ///
  /// In en, this message translates to:
  /// **'Using {method} method for prayer time calculations.'**
  String usingMethodForCalculations(String method);

  /// No description provided for @changeSettings.
  ///
  /// In en, this message translates to:
  /// **'Change settings'**
  String get changeSettings;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @dawnPrayer.
  ///
  /// In en, this message translates to:
  /// **'Dawn Prayer'**
  String get dawnPrayer;

  /// No description provided for @noonPrayer.
  ///
  /// In en, this message translates to:
  /// **'Noon Prayer'**
  String get noonPrayer;

  /// No description provided for @afternoonPrayer.
  ///
  /// In en, this message translates to:
  /// **'Afternoon Prayer'**
  String get afternoonPrayer;

  /// No description provided for @sunsetPrayer.
  ///
  /// In en, this message translates to:
  /// **'Sunset Prayer'**
  String get sunsetPrayer;

  /// No description provided for @nightPrayer.
  ///
  /// In en, this message translates to:
  /// **'Night Prayer'**
  String get nightPrayer;

  /// No description provided for @settingsAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Settings and preferences'**
  String get settingsAndPreferences;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @sunnanQuranieh.
  ///
  /// In en, this message translates to:
  /// **'Sunnan Quranieh'**
  String get sunnanQuranieh;

  /// No description provided for @recommendedSurahs.
  ///
  /// In en, this message translates to:
  /// **'Recommended Surahs'**
  String get recommendedSurahs;

  /// No description provided for @suratAlKahf.
  ///
  /// In en, this message translates to:
  /// **'Surat Al-Kahf'**
  String get suratAlKahf;

  /// No description provided for @suratAlKahfDesc.
  ///
  /// In en, this message translates to:
  /// **'Recite every Friday'**
  String get suratAlKahfDesc;

  /// No description provided for @suratAlKahfProt.
  ///
  /// In en, this message translates to:
  /// **'✨ Protection from Dajjal'**
  String get suratAlKahfProt;

  /// No description provided for @beforeSleep.
  ///
  /// In en, this message translates to:
  /// **'Before Sleep'**
  String get beforeSleep;

  /// No description provided for @beforeSleepDesc.
  ///
  /// In en, this message translates to:
  /// **'Recite before sleep'**
  String get beforeSleepDesc;

  /// No description provided for @beforeSleepProt.
  ///
  /// In en, this message translates to:
  /// **'✨ Protection in the grave'**
  String get beforeSleepProt;

  /// No description provided for @suratAlBaqarah.
  ///
  /// In en, this message translates to:
  /// **'Surat Al-Baqarah'**
  String get suratAlBaqarah;

  /// No description provided for @suratAlBaqarahDesc.
  ///
  /// In en, this message translates to:
  /// **'The longest chapter'**
  String get suratAlBaqarahDesc;

  /// No description provided for @suratAlBaqarahProt.
  ///
  /// In en, this message translates to:
  /// **'✨ Barakah and protection'**
  String get suratAlBaqarahProt;

  /// No description provided for @islamicReminders.
  ///
  /// In en, this message translates to:
  /// **'Islamic Reminders'**
  String get islamicReminders;

  /// No description provided for @morningDhikr.
  ///
  /// In en, this message translates to:
  /// **'Morning Dhikr'**
  String get morningDhikr;

  /// No description provided for @morningDhikrDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily morning remembrance'**
  String get morningDhikrDesc;

  /// No description provided for @eveningDhikr.
  ///
  /// In en, this message translates to:
  /// **'Evening Dhikr'**
  String get eveningDhikr;

  /// No description provided for @eveningDhikrDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily evening remembrance'**
  String get eveningDhikrDesc;

  /// No description provided for @suratAlMulk.
  ///
  /// In en, this message translates to:
  /// **'Surat Al-Mulk'**
  String get suratAlMulk;

  /// No description provided for @suratAlMulkDesc.
  ///
  /// In en, this message translates to:
  /// **'Before sleep protection'**
  String get suratAlMulkDesc;

  /// No description provided for @suratAlBaqarahReminder.
  ///
  /// In en, this message translates to:
  /// **'Surat Al-Baqarah'**
  String get suratAlBaqarahReminder;

  /// No description provided for @suratAlBaqarahReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly recitation'**
  String get suratAlBaqarahReminderDesc;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @audioSettings.
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get audioSettings;

  /// No description provided for @downloadQuran.
  ///
  /// In en, this message translates to:
  /// **'Download Quran'**
  String get downloadQuran;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @accountAndData.
  ///
  /// In en, this message translates to:
  /// **'Account & Data'**
  String get accountAndData;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @readingProgress.
  ///
  /// In en, this message translates to:
  /// **'Reading Progress'**
  String get readingProgress;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpAndFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndFaq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {number}'**
  String version(String number);

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤ for the Muslim Ummah'**
  String get madeWithLove;

  /// No description provided for @privacyProtected.
  ///
  /// In en, this message translates to:
  /// **'Privacy Protected'**
  String get privacyProtected;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'We need your location to calculate accurate prayer times and determine the Qibla direction for your current area.'**
  String get locationPermissionRationale;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in your device settings to use this feature.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @couldNotLoadPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Could not load prayer times'**
  String get couldNotLoadPrayerTimes;

  /// No description provided for @enableLocationForPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Enable location for prayer times'**
  String get enableLocationForPrayerTimes;

  /// No description provided for @todaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayers'**
  String get todaysPrayers;

  /// No description provided for @failedToLoadQibla.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Qibla Data'**
  String get failedToLoadQibla;

  /// No description provided for @ensurePermissions.
  ///
  /// In en, this message translates to:
  /// **'Please ensure location & compass permissions are granted.'**
  String get ensurePermissions;

  /// No description provided for @alignArrowToKaaba.
  ///
  /// In en, this message translates to:
  /// **'Align the arrow with the top to face the Kaaba'**
  String get alignArrowToKaaba;

  /// No description provided for @qiblaDegrees.
  ///
  /// In en, this message translates to:
  /// **'Qibla: {degrees}°'**
  String qiblaDegrees(Object degrees);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
