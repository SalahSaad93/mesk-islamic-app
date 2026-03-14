import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/data/datasources/quran_user_data_datasource.dart';
import 'package:mesk_islamic_app/features/quran/data/services/quran_database_service.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/bookmark_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/highlight_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/note_entity.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestQuranDatabaseService extends QuranDatabaseService {
  @override
  Future<Database> get database async {
    return _initDb();
  }

  Future<Database> _initDb() async {
    return openDatabase(
      inMemoryDatabasePath,
      version: 2,
      onCreate: (db, version) async {
        // Create only user tables for speed, or enough for joins
        await db.execute('CREATE TABLE verses (id INTEGER PRIMARY KEY, surah_number INTEGER, ayah_number INTEGER, text_uthmani TEXT, text_simple TEXT, page INTEGER, juz INTEGER, hizb INTEGER)');
        await db.execute("INSERT INTO verses (id, surah_number, ayah_number, text_uthmani, text_simple, page, juz, hizb) VALUES (1, 1, 1, '', '', 1, 1, 1)");
        
        await db.execute('''
          CREATE TABLE bookmarks (
            id TEXT PRIMARY KEY,
            verse_id INTEGER NOT NULL,
            surah_number INTEGER,
            ayah_number INTEGER,
            surah_name TEXT,
            title TEXT,
            color TEXT DEFAULT '#FFD700',
            created_at TEXT NOT NULL,
            FOREIGN KEY (verse_id) REFERENCES verses(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            verse_id INTEGER NOT NULL,
            surah_number INTEGER,
            ayah_number INTEGER,
            surah_name TEXT,
            text TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (verse_id) REFERENCES verses(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE highlights (
            id TEXT PRIMARY KEY,
            verse_id INTEGER NOT NULL,
            surah_number INTEGER,
            ayah_number INTEGER,
            color TEXT DEFAULT '#FFFF00',
            created_at TEXT NOT NULL,
            FOREIGN KEY (verse_id) REFERENCES verses(id)
          )
        ''');
      },
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late QuranUserDataDatasource datasource;
  late TestQuranDatabaseService dbService;

  setUp(() async {
    dbService = TestQuranDatabaseService();
    datasource = QuranUserDataDatasource(dbService);
  });

  group('QuranUserDataDatasource Integration Tests', () {
    test('Can CRUD Bookmarks', () async {
      final bookmark = BookmarkEntity(
        id: 'b1',
        verseId: 1,
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatiha',
        createdAt: DateTime.now(),
      );

      await datasource.addBookmark(bookmark);
      final list = await datasource.getAllBookmarks();
      expect(list.length, 1);
      expect(list.first.id, 'b1');

      await datasource.deleteBookmark('b1');
      final emptyList = await datasource.getAllBookmarks();
      expect(emptyList.isEmpty, true);
    });

    test('Can CRUD Notes', () async {
      final note = NoteEntity(
        id: 'n1',
        verseId: 1,
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatiha',
        text: 'Test Note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await datasource.addNote(note);
      final list = await datasource.getAllNotes();
      expect(list.length, 1);
      expect(list.first.text, 'Test Note');

      final updatedNote = note.copyWith(text: 'Updated Note');
      await datasource.updateNote(updatedNote);
      final updatedList = await datasource.getAllNotes();
      expect(updatedList.first.text, 'Updated Note');

      await datasource.deleteNote('n1');
      final emptyList = await datasource.getAllNotes();
      expect(emptyList.isEmpty, true);
    });

    test('Note length validation (2000 chars)', () async {
      final longText = 'A' * 2001;
      final note = NoteEntity(
        id: 'n_long',
        verseId: 1,
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatiha',
        text: longText,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(() => datasource.addNote(note), throwsArgumentError);
    });

    test('Can CRUD Highlights', () async {
      final highlight = HighlightEntity(
        id: 'h1',
        verseId: 1,
        surahNumber: 1,
        ayahNumber: 1,
        color: '#FF0000',
        createdAt: DateTime.now(),
      );

      await datasource.addHighlight(highlight);
      final list = await datasource.getAllHighlights();
      expect(list.length, 1);
      expect(list.first.color, '#FF0000');

      await datasource.deleteHighlight('h1');
      final emptyList = await datasource.getAllHighlights();
      expect(emptyList.isEmpty, true);
    });
  });
}
