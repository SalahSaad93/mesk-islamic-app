import 'package:sqflite/sqflite.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/entities/verse_position_entity.dart';
import '../services/quran_database_service.dart';

/// Read-only queries against the Quran database (verses, juz, search).
class QuranDbDatasource {
  final QuranDatabaseService _dbService;

  QuranDbDatasource(this._dbService);

  Future<Database> get _db => _dbService.database;

  /// Get all verses for a given Mushaf page (1–604).
  Future<List<VerseEntity>> getVersesForPage(int page) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'surah_number ASC, ayah_number ASC',
    );
    return rows.map(VerseEntity.fromMap).toList();
  }

  /// Get all verses for a given surah number (1–114).
  Future<List<VerseEntity>> getVersesForSurah(int surahNumber) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'ayah_number ASC',
    );
    return rows.map(VerseEntity.fromMap).toList();
  }

  /// Get a single verse by its global ID.
  Future<VerseEntity?> getVerse(int verseId) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'id = ?',
      whereArgs: [verseId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return VerseEntity.fromMap(rows.first);
  }

  /// Get a verse by surah number and ayah number.
  Future<VerseEntity?> getVerseByReference(
    int surahNumber,
    int ayahNumber,
  ) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'surah_number = ? AND ayah_number = ?',
      whereArgs: [surahNumber, ayahNumber],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return VerseEntity.fromMap(rows.first);
  }

  /// Search verses by text (Arabic simple form).
  Future<List<VerseEntity>> searchVerses(String query, {int limit = 50}) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'text_simple LIKE ? OR text_uthmani LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'surah_number ASC, ayah_number ASC',
      limit: limit,
    );
    return rows.map(VerseEntity.fromMap).toList();
  }

  /// Get total verse count (should be 6236).
  Future<int> getVerseCount() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) AS cnt FROM verses');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get all 30 Juz entries.
  Future<List<JuzEntity>> getAllJuz() async {
    final db = await _db;
    final rows = await db.query('juz', orderBy: 'juz_number ASC');
    return rows.map(JuzEntity.fromMap).toList();
  }

  /// Get the Juz entry for a given page.
  Future<JuzEntity?> getJuzForPage(int page) async {
    final db = await _db;
    final rows = await db.query(
      'juz',
      where: 'start_page <= ? AND end_page >= ?',
      whereArgs: [page, page],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return JuzEntity.fromMap(rows.first);
  }

  /// Get the page number for a surah's first verse.
  Future<int> getPageForSurah(int surahNumber) async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT MIN(page) AS p FROM verses WHERE surah_number = ?',
      [surahNumber],
    );
    return Sqflite.firstIntValue(result) ?? 1;
  }

  /// Get all distinct surah numbers and their first ayah page on a given page.
  Future<List<int>> getSurahsOnPage(int page) async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT DISTINCT surah_number FROM verses WHERE page = ? ORDER BY surah_number ASC',
      [page],
    );
    return rows.map((r) => r['surah_number'] as int).toList();
  }

  /// Get the first verse position on a given Mushaf page.
  Future<VersePositionEntity> getFirstVerseOnPage(int page) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'surah_number ASC, ayah_number ASC',
      limit: 1,
    );
    if (rows.isEmpty) {
      return const VersePositionEntity(
        surahNumber: 1,
        ayahNumber: 1,
        page: 1,
      );
    }
    final verse = VerseEntity.fromMap(rows.first);
    return VersePositionEntity(
      surahNumber: verse.surahNumber,
      ayahNumber: verse.ayahNumber,
      page: verse.page,
    );
  }

  /// Get the Mushaf page number for a given verse reference.
  Future<int> getPageForVerse(int surahNumber, int ayahNumber) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      columns: ['page'],
      where: 'surah_number = ? AND ayah_number = ?',
      whereArgs: [surahNumber, ayahNumber],
      limit: 1,
    );
    if (rows.isEmpty) return 1;
    return rows.first['page'] as int;
  }
}
