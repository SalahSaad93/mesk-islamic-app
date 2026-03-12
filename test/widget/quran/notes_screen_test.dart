import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/note_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/providers/user_data_provider.dart';
import 'package:mesk_islamic_app/features/quran/presentation/screens/notes_screen.dart';

void main() {
  group('NotesScreen Widget Tests', () {
    testWidgets('Displays empty state when no notes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith(() => MockNotesNotifier([])),
          ],
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No notes yet'), findsOneWidget);
    });

    testWidgets('Displays list of notes', (tester) async {
      final notes = [
        NoteEntity(
          id: '1',
          verseId: 101,
          surahNumber: 1,
          ayahNumber: 1,
          surahName: 'Al-Fatiha',
          text: 'Note 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith(() => MockNotesNotifier(notes)),
          ],
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Note 1'), findsOneWidget);
      expect(find.text('Al-Fatiha, Ayah 1'), findsOneWidget);
    });
  });
}

class MockNotesNotifier extends NotesNotifier {
  final List<NoteEntity> initialNotes;
  MockNotesNotifier(this.initialNotes);

  @override
  Future<List<NoteEntity>> build() async => initialNotes;
}
