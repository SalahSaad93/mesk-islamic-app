import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reciter_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/providers/reciter_provider.dart';
import 'package:mesk_islamic_app/features/quran/presentation/widgets/reciter_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  testWidgets('ReciterPickerSheet displays list of reciters', (tester) async {
    final reciters = [
      const ReciterEntity(
        id: '1',
        nameArabic: 'Arabic 1',
        nameEnglish: 'English 1',
        style: 'Style 1',
        audioBaseUrl: 'Url 1',
      ),
    ];

    final mockStorage = MockStorageService();
    when(() => mockStorage.selectedReciterId).thenReturn('1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(mockStorage),
          recitersProvider.overrideWith((ref) => reciters),
        ],
        child: const MaterialApp(
          home: Scaffold(body: ReciterPickerSheet()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('English 1'), findsOneWidget);
    expect(find.text('Arabic 1'), findsOneWidget);
  });
}
