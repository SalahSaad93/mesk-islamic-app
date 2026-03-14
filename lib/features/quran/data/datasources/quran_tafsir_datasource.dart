import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/tafsir_entity.dart';
import '../services/quran_database_service.dart';

class QuranTafsirDatasource {
  final QuranDatabaseService _dbService;
  static const String _baseUrl = 'https://api.quran.com/api/v4';

  QuranTafsirDatasource(this._dbService);

  Future<Database> get _db => _dbService.database;

  Future<TafsirEntity?> getTafsir(int verseId, String source) async {
    final db = await _db;
    
    final rows = await db.query(
      'tafsir_cache',
      where: 'verse_id = ? AND source = ?',
      whereArgs: [verseId, source],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      return TafsirEntity.fromMap(rows.first);
    }

    return await _fetchAndCacheTafsir(verseId, source);
  }

  Future<TafsirEntity?> _fetchAndCacheTafsir(int verseId, String source) async {
    try {
      final surahNumber = (verseId - 1) ~/ 100 + 1;
      final ayahNumber = ((verseId - 1) % 100) + 1;
      
      final response = await http.get(
        Uri.parse('$_baseUrl/tafsirs/$source/by_ayah/$surahNumber:$ayahNumber'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tafsirText = data['data']['text'] as String;
        
        final tafsir = TafsirEntity(
          verseId: verseId,
          source: source,
          text: tafsirText,
          cachedAt: DateTime.now(),
        );

        final db = await _db;
        await db.insert(
          'tafsir_cache',
          tafsir.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return tafsir;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<TafsirEntity>> getTafsirForPage(int page, String source) async {
    final db = await _db;
    
    final rows = await db.rawQuery('''
      SELECT t.* FROM tafsir_cache t
      INNER JOIN verses v ON t.verse_id = v.id
      WHERE v.page = ? AND t.source = ?
    ''', [page, source]);

    return rows.map((row) => TafsirEntity.fromMap(row)).toList();
  }

  Future<void> clearCache() async {
    final db = await _db;
    await db.delete('tafsir_cache');
  }
}
