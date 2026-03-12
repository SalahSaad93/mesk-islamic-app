import 'package:sqflite/sqflite.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../services/quran_database_service.dart';

/// CRUD operations for bookmarks, notes, and highlights.
class QuranUserDataDatasource {
  final QuranDatabaseService _dbService;

  QuranUserDataDatasource(this._dbService);

  Future<Database> get _db => _dbService.database;

  // ===== BOOKMARKS =====

  Future<List<BookmarkEntity>> getAllBookmarks() async {
    final db = await _db;
    final rows = await db.query(
      'bookmarks',
      orderBy: 'created_at DESC',
    );
    return rows.map((r) => BookmarkEntity.fromMap(r)).toList();
  }

  Future<BookmarkEntity?> getBookmarkForVerse(int verseId) async {
    final db = await _db;
    final rows = await db.query(
      'bookmarks',
      where: 'verse_id = ?',
      whereArgs: [verseId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return BookmarkEntity.fromMap(rows.first);
  }

  Future<void> addBookmark(BookmarkEntity bookmark) async {
    final db = await _db;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String id) async {
    final db = await _db;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateBookmark(BookmarkEntity bookmark) async {
    final db = await _db;
    await db.update(
      'bookmarks',
      bookmark.toMap(),
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  // ===== NOTES =====

  Future<List<NoteEntity>> getAllNotes() async {
    final db = await _db;
    final rows = await db.query(
      'notes',
      orderBy: 'updated_at DESC',
    );
    return rows.map((r) => NoteEntity.fromMap(r)).toList();
  }

  Future<NoteEntity?> getNoteForVerse(int verseId) async {
    final db = await _db;
    final rows = await db.query(
      'notes',
      where: 'verse_id = ?',
      whereArgs: [verseId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return NoteEntity.fromMap(rows.first);
  }

  Future<void> addNote(NoteEntity note) async {
    if (note.text.length > 2000) {
      throw ArgumentError('Note text cannot exceed 2000 characters');
    }
    final db = await _db;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(NoteEntity note) async {
    if (note.text.length > 2000) {
      throw ArgumentError('Note text cannot exceed 2000 characters');
    }
    final db = await _db;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _db;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ===== HIGHLIGHTS =====

  Future<List<HighlightEntity>> getAllHighlights() async {
    final db = await _db;
    final rows = await db.query(
      'highlights',
      orderBy: 'created_at DESC',
    );
    return rows.map((r) => HighlightEntity.fromMap(r)).toList();
  }

  Future<HighlightEntity?> getHighlightForVerse(int verseId) async {
    final db = await _db;
    final rows = await db.query(
      'highlights',
      where: 'verse_id = ?',
      whereArgs: [verseId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HighlightEntity.fromMap(rows.first);
  }

  Future<Map<int, HighlightEntity>> getHighlightsForPage(int page) async {
    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT h.*, v.surah_number, v.ayah_number
      FROM highlights h
      INNER JOIN verses v ON h.verse_id = v.id
      WHERE v.page = ?
    ''',
      [page],
    );
    final map = <int, HighlightEntity>{};
    for (final r in rows) {
      final h = HighlightEntity.fromMap(r);
      map[h.verseId] = h;
    }
    return map;
  }

  Future<void> addHighlight(HighlightEntity highlight) async {
    final db = await _db;
    await db.insert(
      'highlights',
      highlight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteHighlight(String id) async {
    final db = await _db;
    await db.delete('highlights', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteHighlightForVerse(int verseId) async {
    final db = await _db;
    await db.delete('highlights', where: 'verse_id = ?', whereArgs: [verseId]);
  }
}
