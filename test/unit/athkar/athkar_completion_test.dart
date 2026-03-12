import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';
import 'package:mesk_islamic_app/features/athkar/presentation/providers/athkar_provider.dart';
import 'package:mesk_islamic_app/features/athkar/domain/entities/thikr_entity.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;
  late AthkarProgressNotifier notifier;
  const category = 'morning';

  setUp(() {
    mockStorage = MockStorageService();
    when(() => mockStorage.getAthkarLastReset(any())).thenReturn(null);
    when(() => mockStorage.getAthkarProgress(any())).thenReturn(null);
    when(() => mockStorage.saveAthkarProgress(any(), any())).thenAnswer((_) async {});
    notifier = AthkarProgressNotifier(mockStorage, category);
  });

  group('AthkarProgressNotifier Completion Logic', () {
    final athkar = [
      const ThikrEntity(
        id: 1,
        arabic: 'A',
        translation: 'T',
        transliteration: 'TR',
        source: 'S',
        repeatCount: 3,
        category: category,
        reference: 'R',
      ),
      const ThikrEntity(
        id: 2,
        arabic: 'B',
        translation: 'T',
        transliteration: 'TR',
        source: 'S',
        repeatCount: 1,
        category: category,
        reference: 'R',
      ),
    ];

    test('isAllDone returns true only when all items are at 0', () {
      notifier.initProgress(athkar);
      expect(notifier.isAllDone, false);

      notifier.decrement(1);
      notifier.decrement(1);
      notifier.decrement(1);
      expect(notifier.isAllDone, false); // Item 2 still has 1

      notifier.decrement(2);
      expect(notifier.isAllDone, true);
    });

    test('isAllDone returns false if empty', () {
      expect(notifier.isAllDone, false);
    });

    test('decrement does not go below zero', () {
      notifier.initProgress(athkar);
      notifier.decrement(2);
      expect(notifier.state[2], 0);
      notifier.decrement(2);
      expect(notifier.state[2], 0);
    });
  });
}
