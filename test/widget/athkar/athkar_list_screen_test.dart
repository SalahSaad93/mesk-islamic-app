import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mesk_islamic_app/features/athkar/presentation/screens/athkar_list_screen.dart';
import 'package:mesk_islamic_app/features/athkar/presentation/providers/athkar_provider.dart';
import 'package:mesk_islamic_app/features/athkar/domain/entities/thikr_entity.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';

class MockAthkarProgressNotifier extends StateNotifier<Map<int, int>>
    with Mock
    implements AthkarProgressNotifier {
  MockAthkarProgressNotifier() : super({});
}

class MockStorageService extends Mock implements StorageService {}

void main() {
  const category = 'morning';
  final testAthkar = [
    const ThikrEntity(
      id: 1,
      arabic: 'A',
      translation: 'T',
      transliteration: 'TR',
      source: 'S',
      repeatCount: 1,
      category: category,
      reference: 'R',
    ),
  ];

  testWidgets('AthkarListScreen shows RefreshIndicator and resets progress', (tester) async {
    final mockNotifier = MockAthkarProgressNotifier();
    final mockStorage = MockStorageService();

    // Use setter since it's a Mock that implements AthkarProgressNotifier
    // Actually, for StateNotifier, we should let it behave naturally if possible,
    // but here we just want to verify reset() call.
    when(() => mockNotifier.reset(any())).thenAnswer((_) async {});
    when(() => mockNotifier.isDone(any())).thenReturn(false);
    when(() => mockNotifier.initProgress(any())).thenReturn(null);
    // Ignore state mock for now as it's causing issues with mocktail

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(mockStorage),
          athkarByCategoryProvider(category).overrideWith((ref) async => testAthkar),
          athkarProgressProvider(category).overrideWith((ref) => mockNotifier),
        ],
        child: const MaterialApp(
          home: AthkarListScreen(
            category: category,
            title: 'Morning Athkar',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final refreshIndicator = find.byType(RefreshIndicator);
    expect(refreshIndicator, findsOneWidget);

    // Trigger pull-to-refresh
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockNotifier.reset(any())).called(1);
  });
}
