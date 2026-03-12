import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/notification_service.dart';

class SettingsState {
  final bool isDarkMode;
  final String language;
  final String calculationMethod;
  final String readingMode;
  final bool morningDhikr;
  final bool eveningDhikr;
  final bool surahKahf;
  final bool surahBaqarah;
  final bool dailyVerse;

  const SettingsState({
    this.isDarkMode = false,
    this.language = 'ar',
    this.calculationMethod = 'ISNA',
    this.readingMode = 'mushafPage',
    this.morningDhikr = true,
    this.eveningDhikr = false,
    this.surahKahf = false,
    this.surahBaqarah = false,
    this.dailyVerse = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    String? calculationMethod,
    String? readingMode,
    bool? morningDhikr,
    bool? eveningDhikr,
    bool? surahKahf,
    bool? surahBaqarah,
    bool? dailyVerse,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      readingMode: readingMode ?? this.readingMode,
      morningDhikr: morningDhikr ?? this.morningDhikr,
      eveningDhikr: eveningDhikr ?? this.eveningDhikr,
      surahKahf: surahKahf ?? this.surahKahf,
      surahBaqarah: surahBaqarah ?? this.surahBaqarah,
      dailyVerse: dailyVerse ?? this.dailyVerse,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsState> {
  late StorageService _storage;

  @override
  SettingsState build() {
    _storage = ref.watch(storageServiceProvider);

    // In Phase 3, we would load all actual values from SharedPreferences, but for Phase 2
    // we just need the language.
    return SettingsState(
      isDarkMode: _storage.isDarkMode,
      language: _storage.language,
      calculationMethod: _storage.calculationMethod,
      readingMode: _storage.readingMode,
      morningDhikr: _storage.getPrayerNotification(
        'morningDhikr',
      ), // Using generalized key for now
      eveningDhikr: _storage.getPrayerNotification('eveningDhikr'),
      surahKahf: _storage.getPrayerNotification('surahKahf'),
      surahBaqarah: _storage.getPrayerNotification('surahBaqarah'),
      dailyVerse: _storage.getPrayerNotification('dailyVerse'),
    );
  }

  void setLanguage(String langCode) {
    _storage.setLanguage(langCode);
    state = state.copyWith(language: langCode);
  }

  void toggleDarkMode(bool value) {
    _storage.setDarkMode(value);
    state = state.copyWith(isDarkMode: value);
  }

  void setCalculationMethod(String method) {
    _storage.setCalculationMethod(method);
    state = state.copyWith(calculationMethod: method);
  }

  void toggleMorningDhikr(bool value) {
    _storage.setPrayerNotification('morningDhikr', value);
    state = state.copyWith(morningDhikr: value);
    if (value) {
      ref
          .read(notificationServiceProvider)
          .scheduleAthkarReminder(
            id: 11,
            category: 'Morning',
            timeOfDay: const TimeOfDay(hour: 7, minute: 0),
          );
    } else {
      ref.read(notificationServiceProvider).cancelNotification(11);
    }
  }

  void toggleEveningDhikr(bool value) {
    _storage.setPrayerNotification('eveningDhikr', value);
    state = state.copyWith(eveningDhikr: value);
    if (value) {
      ref
          .read(notificationServiceProvider)
          .scheduleAthkarReminder(
            id: 12,
            category: 'Evening',
            timeOfDay: const TimeOfDay(hour: 17, minute: 0),
          );
    } else {
      ref.read(notificationServiceProvider).cancelNotification(12);
    }
  }

  void toggleSurahKahf(bool value) {
    _storage.setPrayerNotification('surahKahf', value);
    state = state.copyWith(surahKahf: value);
  }

  void toggleSurahBaqarah(bool value) {
    _storage.setPrayerNotification('surahBaqarah', value);
    state = state.copyWith(surahBaqarah: value);
  }

  void toggleDailyVerse(bool value) {
    _storage.setPrayerNotification('dailyVerse', value);
    state = state.copyWith(dailyVerse: value);
    if (value) {
      ref
          .read(notificationServiceProvider)
          .scheduleDailyVerseNotification(
            id: 10,
            timeOfDay: const TimeOfDay(hour: 12, minute: 0),
          );
    } else {
      ref.read(notificationServiceProvider).cancelNotification(10);
    }
  }

  void initializeNotifications() {
    if (state.morningDhikr) {
      ref
          .read(notificationServiceProvider)
          .scheduleAthkarReminder(
            id: 11,
            category: 'Morning',
            timeOfDay: const TimeOfDay(hour: 7, minute: 0),
          );
    }
    if (state.eveningDhikr) {
      ref
          .read(notificationServiceProvider)
          .scheduleAthkarReminder(
            id: 12,
            category: 'Evening',
            timeOfDay: const TimeOfDay(hour: 17, minute: 0),
          );
    }
    if (state.dailyVerse) {
      ref
          .read(notificationServiceProvider)
          .scheduleDailyVerseNotification(
            id: 10,
            timeOfDay: const TimeOfDay(hour: 12, minute: 0),
          );
    }
  }
}
