import 'package:sqflite/sqflite.dart';
import '../../domain/entities/translation_entity.dart';
import '../services/quran_database_service.dart';
import 'dart:async' show Future;

/// Queries against the translations table in the Quran database.
class QuranTranslationDatasource {
  final QuranDatabaseService _dbService;

  QuranTranslationDatasource(this._dbService);

  Future<Database> get _db => _dbService.database;

  /// Get translation for a specific verse.
  Future<TranslationEntity?> getTranslationForVerse(int verseId, String language) async {
    final db = await _db;
    final rows = await db.query(
      'translations',
      where: 'verse_id = ? AND language = ?',
      whereArgs: [verseId, language],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TranslationEntity.fromMap(rows.first);
  }

  /// Get all translations for a given Mushaf page.
  Future<List<TranslationEntity>> getTranslationsForPage(int page, String language) async {
    final db = await _db;
    final rows = await db.query(
      'translations',
      where: 'verse_id IN (SELECT id FROM verses WHERE page = ?) AND language = ?',
      whereArgs: [page, language],
      orderBy: 'verse_id ASC',
    );
    return rows.map(TranslationEntity.fromMap).toList();
  }

  /// Get all translations for a given surah.
  Future<List<TranslationEntity>> getTranslationsForSurah(int surahNumber, String language) async {
    final db = await _db;
    final rows = await db.query(
      'translations',
      where: 'verse_id IN (SELECT id FROM verses WHERE surah_number = ?) AND language = ?',
      whereArgs: [surahNumber, language],
      orderBy: 'verse_id ASC',
    );
    return rows.map(TranslationEntity.fromMap).toList();
  }

  /// Get all translations for a specific verse.
  Future<List<TranslationEntity>> getTranslationsForVerse(int verseId, String language) async {
    final db = await _db;
    final rows = await db.query(
      'translations',
      where: 'verse_id = ? AND language = ?',
      whereArgs: [verseId, language],
      orderBy: 'verse_id ASC',
    );
    return rows.map(TranslationEntity.fromMap).toList();
  }
}
