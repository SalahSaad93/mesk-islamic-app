import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reading_preferences_entity.dart';

void main() {
  group('ReadingPreferencesEntity', () {
    test('should have default values', () {
      final prefs = ReadingPreferencesEntity();
      
      expect(prefs.fontSize, 2);
      expect(prefs.nightMode, false);
      expect(prefs.showTranslation, false);
    });

    test('should create with custom values', () {
      final prefs = ReadingPreferencesEntity(
        fontSize: 3,
        nightMode: true,
        showTranslation: true,
      );
      
      expect(prefs.fontSize, 3);
      expect(prefs.nightMode, true);
      expect(prefs.showTranslation, true);
    });

    test('copyWith should update specific fields', () {
      final prefs = ReadingPreferencesEntity(
        fontSize: 2,
        nightMode: false,
        showTranslation: false,
      );

      final updated = prefs.copyWith(fontSize: 4);
      
      expect(updated.fontSize, 4);
      expect(updated.nightMode, false);
      expect(updated.showTranslation, false);
    });

    test('copyWith should preserve other fields when not specified', () {
      final prefs = ReadingPreferencesEntity(
        fontSize: 3,
        nightMode: true,
        showTranslation: true,
      );

      final updated = prefs.copyWith(nightMode: false);
      
      expect(updated.fontSize, 3);
      expect(updated.nightMode, false);
      expect(updated.showTranslation, true);
    });

    test('fromMap should parse correctly', () {
      final map = {
        'font_size': 4,
        'night_mode': true,
        'show_translation': true,
      };

      final prefs = ReadingPreferencesEntity.fromMap(map);
      
      expect(prefs.fontSize, 4);
      expect(prefs.nightMode, true);
      expect(prefs.showTranslation, true);
    });

    test('fromMap should use defaults for missing keys', () {
      final map = <String, dynamic>{};

      final prefs = ReadingPreferencesEntity.fromMap(map);
      
      expect(prefs.fontSize, 2);
      expect(prefs.nightMode, false);
      expect(prefs.showTranslation, false);
    });

    test('toMap should serialize correctly', () {
      final prefs = ReadingPreferencesEntity(
        fontSize: 3,
        nightMode: true,
        showTranslation: false,
      );

      final map = prefs.toMap();
      
      expect(map['font_size'], 3);
      expect(map['night_mode'], true);
      expect(map['show_translation'], false);
    });

    test('ReadingMode enum should have correct values', () {
      expect(ReadingMode.values.length, 2);
      expect(ReadingMode.values.contains(ReadingMode.verseMode), true);
      expect(ReadingMode.values.contains(ReadingMode.fullQuranMode), true);
    });
  });
}
