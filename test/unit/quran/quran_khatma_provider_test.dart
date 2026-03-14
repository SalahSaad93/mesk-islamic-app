import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';
import 'package:mesk_islamic_app/features/quran/presentation/providers/quran_khatma_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('KhatmaProvider', () {
    late StorageService storageService;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getInt('khatma_highest_page')).thenReturn(0);
      when(
        () => mockPrefs.getString('khatma_start_date'),
      ).thenReturn(DateTime.now().toIso8601String());
      when(() => mockPrefs.getBool('khatma_completed')).thenReturn(false);
      when(
        () => mockPrefs.setInt('khatma_highest_page', any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPrefs.setString('khatma_start_date', any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPrefs.setBool('khatma_completed', any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.clear()).thenAnswer((_) async => true);

      storageService = StorageService(mockPrefs);
    });

    test('initial state has zero progress', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final state = container.read(khatmaProvider);
      expect(state.highestPage, 0);
      expect(state.isCompleted, false);
      expect(state.percentage, 0.0);

      container.dispose();
    });

    test('onPageRead increments highest page correctly', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);
      final state = container.read(khatmaProvider);

      expect(state.highestPage, 0);

      notifier.onPageRead(100);
      var newState = container.read(khatmaProvider);
      expect(newState.highestPage, 100);

      notifier.onPageRead(200);
      newState = container.read(khatmaProvider);
      expect(newState.highestPage, 200);

      notifier.onPageRead(50);
      newState = container.read(khatmaProvider);
      expect(newState.highestPage, 200);

      container.dispose();
    });

    test('detects completion at page 604', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);

      expect(container.read(khatmaProvider).isCompleted, false);

      notifier.onPageRead(604);
      var newState = container.read(khatmaProvider);
      expect(newState.isCompleted, true);
      expect(newState.percentage, 100.0);

      container.dispose();
    });

    test('resets khatma progress', () async {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);

      notifier.onPageRead(604);
      await notifier.resetKhatma();

      final newState = container.read(khatmaProvider);
      expect(newState.highestPage, 0);
      expect(newState.isCompleted, false);
      expect(newState.percentage, 0.0);

      container.dispose();
    });

    test('persists progress across provider recreations', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);

      notifier.onPageRead(300);
      notifier.onPageRead(400);

      var state = container.read(khatmaProvider);
      expect(state.highestPage, 400);
      expect(state.percentage, (400 / 604) * 100);

      container.dispose();
    });

    test('progress percentage calculation is correct', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);

      expect(notifier.percentage, 0.0);

      notifier.onPageRead(151);
      expect(notifier.percentage, 25.0);

      notifier.onPageRead(453);
      expect(notifier.percentage, 75.0);

      notifier.onPageRead(604);
      expect(notifier.percentage, 100.0);

      container.dispose();
    });

    test('completion detection is false until 604 is reached', () {
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );

      final notifier = container.read(khatmaProvider.notifier);

      notifier.onPageRead(1);
      expect(notifier.percentage, 0.17);
      expect(container.read(khatmaProvider).isCompleted, false);

      notifier.onPageRead(300);
      expect(notifier.percentage, 49.7);
      expect(container.read(khatmaProvider).isCompleted, false);

      notifier.onPageRead(603);
      expect(notifier.percentage, 99.84);
      expect(container.read(khatmaProvider).isCompleted, false);

      container.dispose();
    });
  });
}
