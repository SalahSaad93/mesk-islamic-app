import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('StorageService', () {
    late StorageService storageService;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      storageService = StorageService(mockPrefs);
    });

    test('language should return "ar" as default if no value is stored', () {
      // Arrange
      when(() => mockPrefs.getString('language')).thenReturn(null);

      // Act
      final result = storageService.language;

      // Assert
      // This is expected to fail initially as it returns 'en'
      expect(result, 'ar');
    });

    test('language should return stored value if it exists', () {
      // Arrange
      when(() => mockPrefs.getString('language')).thenReturn('en');

      // Act
      final result = storageService.language;

      // Assert
      expect(result, 'en');
    });
  });
}
