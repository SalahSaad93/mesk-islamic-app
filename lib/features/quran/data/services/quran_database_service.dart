import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// Provides the single SQLite database instance used for all Quran data.
///
/// On first launch the DB is created and populated from JSON assets.
/// On subsequent launches we skip the seed and just return the DB.
class QuranDatabaseService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = p.join(await getDatabasesPath(), 'mesk_quran.db');

    return openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedFromAssets(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createUserTables(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Core read-only Quran data
    await db.execute('''
      CREATE TABLE IF NOT EXISTS verses (
        id INTEGER PRIMARY KEY,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        text_uthmani TEXT NOT NULL,
        text_simple TEXT NOT NULL,
        page INTEGER NOT NULL,
        juz INTEGER NOT NULL,
        hizb INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS juz (
        juz_number INTEGER PRIMARY KEY,
        name_arabic TEXT NOT NULL,
        start_surah INTEGER NOT NULL,
        start_ayah INTEGER NOT NULL,
        end_surah INTEGER NOT NULL,
        end_ayah INTEGER NOT NULL,
        start_page INTEGER NOT NULL,
        end_page INTEGER NOT NULL
      )
    ''');

    await _createUserTables(db);
  }

  Future<void> _createUserTables(Database db) async {
    // User data: bookmarks, notes, highlights
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookmarks (
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
      CREATE TABLE IF NOT EXISTS notes (
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
      CREATE TABLE IF NOT EXISTS highlights (
        id TEXT PRIMARY KEY,
        verse_id INTEGER NOT NULL,
        surah_number INTEGER,
        ayah_number INTEGER,
        color TEXT DEFAULT '#FFFF00',
        created_at TEXT NOT NULL,
        FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    // Performance indices
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_verses_page ON verses(page)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_verses_surah ON verses(surah_number)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_bookmarks_verse ON bookmarks(verse_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_verse ON notes(verse_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_highlights_verse ON highlights(verse_id)',
    );
  }

  /// Seeds the verses table from surahs.json + the Quran API bulk JSON.
  Future<void> _seedFromAssets(Database db) async {
    // Seed juz data
    await _seedJuzData(db);

    // Seed all verse data from quran_verses.json
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/quran_verses.json',
      );
      final List<dynamic> verses = json.decode(jsonStr);

      const batchSize = 200;
      for (var i = 0; i < verses.length; i += batchSize) {
        final batch = db.batch();
        final end = (i + batchSize > verses.length)
            ? verses.length
            : i + batchSize;
        for (var j = i; j < end; j++) {
          final v = verses[j] as Map<String, dynamic>;
          batch.insert('verses', {
            'id': v['id'],
            'surah_number': v['surah_number'],
            'ayah_number': v['ayah_number'],
            'text_uthmani': v['text_uthmani'],
            'text_simple': v['text_simple'],
            'page': v['page'],
            'juz': v['juz'],
            'hizb': v['hizb'],
          });
        }
        await batch.commit(noResult: true);
      }
    } catch (e) {
      // Silently fail if quran_verses.json is missing —
      // it will be populated once the actual asset is added.
      debugPrintStack(label: 'QuranDB seed error: $e');
    }
  }

  Future<void> _seedJuzData(Database db) async {
    // Standard 30-Juz start/end data
    const juzData = [
      {
        'juz_number': 1,
        'name_arabic': 'الم',
        'start_surah': 1,
        'start_ayah': 1,
        'end_surah': 2,
        'end_ayah': 141,
        'start_page': 1,
        'end_page': 21,
      },
      {
        'juz_number': 2,
        'name_arabic': 'سَيَقُولُ',
        'start_surah': 2,
        'start_ayah': 142,
        'end_surah': 2,
        'end_ayah': 252,
        'start_page': 22,
        'end_page': 41,
      },
      {
        'juz_number': 3,
        'name_arabic': 'تِلْكَ الرُّسُلُ',
        'start_surah': 2,
        'start_ayah': 253,
        'end_surah': 3,
        'end_ayah': 92,
        'start_page': 42,
        'end_page': 61,
      },
      {
        'juz_number': 4,
        'name_arabic': 'لَنْ تَنَالُوا',
        'start_surah': 3,
        'start_ayah': 93,
        'end_surah': 4,
        'end_ayah': 23,
        'start_page': 62,
        'end_page': 81,
      },
      {
        'juz_number': 5,
        'name_arabic': 'وَالْمُحْصَنَاتُ',
        'start_surah': 4,
        'start_ayah': 24,
        'end_surah': 4,
        'end_ayah': 147,
        'start_page': 82,
        'end_page': 101,
      },
      {
        'juz_number': 6,
        'name_arabic': 'لَا يُحِبُّ اللَّهُ',
        'start_surah': 4,
        'start_ayah': 148,
        'end_surah': 5,
        'end_ayah': 81,
        'start_page': 102,
        'end_page': 121,
      },
      {
        'juz_number': 7,
        'name_arabic': 'وَإِذَا سَمِعُوا',
        'start_surah': 5,
        'start_ayah': 82,
        'end_surah': 6,
        'end_ayah': 110,
        'start_page': 122,
        'end_page': 141,
      },
      {
        'juz_number': 8,
        'name_arabic': 'وَلَوْ أَنَّنَا',
        'start_surah': 6,
        'start_ayah': 111,
        'end_surah': 7,
        'end_ayah': 87,
        'start_page': 142,
        'end_page': 161,
      },
      {
        'juz_number': 9,
        'name_arabic': 'قَالَ الْمَلَأُ',
        'start_surah': 7,
        'start_ayah': 88,
        'end_surah': 8,
        'end_ayah': 40,
        'start_page': 162,
        'end_page': 181,
      },
      {
        'juz_number': 10,
        'name_arabic': 'وَاعْلَمُوا',
        'start_surah': 8,
        'start_ayah': 41,
        'end_surah': 9,
        'end_ayah': 92,
        'start_page': 182,
        'end_page': 201,
      },
      {
        'juz_number': 11,
        'name_arabic': 'يَعْتَذِرُونَ',
        'start_surah': 9,
        'start_ayah': 93,
        'end_surah': 11,
        'end_ayah': 5,
        'start_page': 202,
        'end_page': 221,
      },
      {
        'juz_number': 12,
        'name_arabic': 'وَمَا مِنْ دَابَّةٍ',
        'start_surah': 11,
        'start_ayah': 6,
        'end_surah': 12,
        'end_ayah': 52,
        'start_page': 222,
        'end_page': 241,
      },
      {
        'juz_number': 13,
        'name_arabic': 'وَمَا أُبَرِّئُ',
        'start_surah': 12,
        'start_ayah': 53,
        'end_surah': 14,
        'end_ayah': 52,
        'start_page': 242,
        'end_page': 261,
      },
      {
        'juz_number': 14,
        'name_arabic': 'رُبَمَا',
        'start_surah': 15,
        'start_ayah': 1,
        'end_surah': 16,
        'end_ayah': 128,
        'start_page': 262,
        'end_page': 281,
      },
      {
        'juz_number': 15,
        'name_arabic': 'سُبْحَانَ',
        'start_surah': 17,
        'start_ayah': 1,
        'end_surah': 18,
        'end_ayah': 74,
        'start_page': 282,
        'end_page': 301,
      },
      {
        'juz_number': 16,
        'name_arabic': 'قَالَ أَلَمْ',
        'start_surah': 18,
        'start_ayah': 75,
        'end_surah': 20,
        'end_ayah': 135,
        'start_page': 302,
        'end_page': 321,
      },
      {
        'juz_number': 17,
        'name_arabic': 'اقْتَرَبَ',
        'start_surah': 21,
        'start_ayah': 1,
        'end_surah': 22,
        'end_ayah': 78,
        'start_page': 322,
        'end_page': 341,
      },
      {
        'juz_number': 18,
        'name_arabic': 'قَدْ أَفْلَحَ',
        'start_surah': 23,
        'start_ayah': 1,
        'end_surah': 25,
        'end_ayah': 20,
        'start_page': 342,
        'end_page': 361,
      },
      {
        'juz_number': 19,
        'name_arabic': 'وَقَالَ الَّذِينَ',
        'start_surah': 25,
        'start_ayah': 21,
        'end_surah': 27,
        'end_ayah': 55,
        'start_page': 362,
        'end_page': 381,
      },
      {
        'juz_number': 20,
        'name_arabic': 'أَمَّنْ خَلَقَ',
        'start_surah': 27,
        'start_ayah': 56,
        'end_surah': 29,
        'end_ayah': 45,
        'start_page': 382,
        'end_page': 401,
      },
      {
        'juz_number': 21,
        'name_arabic': 'اتْلُ مَا أُوحِيَ',
        'start_surah': 29,
        'start_ayah': 46,
        'end_surah': 33,
        'end_ayah': 30,
        'start_page': 402,
        'end_page': 421,
      },
      {
        'juz_number': 22,
        'name_arabic': 'وَمَنْ يَقْنُتْ',
        'start_surah': 33,
        'start_ayah': 31,
        'end_surah': 36,
        'end_ayah': 27,
        'start_page': 422,
        'end_page': 441,
      },
      {
        'juz_number': 23,
        'name_arabic': 'وَمَا لِيَ',
        'start_surah': 36,
        'start_ayah': 28,
        'end_surah': 39,
        'end_ayah': 31,
        'start_page': 442,
        'end_page': 461,
      },
      {
        'juz_number': 24,
        'name_arabic': 'فَمَنْ أَظْلَمُ',
        'start_surah': 39,
        'start_ayah': 32,
        'end_surah': 41,
        'end_ayah': 46,
        'start_page': 462,
        'end_page': 481,
      },
      {
        'juz_number': 25,
        'name_arabic': 'إِلَيْهِ يُرَدُّ',
        'start_surah': 41,
        'start_ayah': 47,
        'end_surah': 45,
        'end_ayah': 37,
        'start_page': 482,
        'end_page': 501,
      },
      {
        'juz_number': 26,
        'name_arabic': 'حم',
        'start_surah': 46,
        'start_ayah': 1,
        'end_surah': 51,
        'end_ayah': 30,
        'start_page': 502,
        'end_page': 521,
      },
      {
        'juz_number': 27,
        'name_arabic': 'قَالَ فَمَا خَطْبُكُمْ',
        'start_surah': 51,
        'start_ayah': 31,
        'end_surah': 57,
        'end_ayah': 29,
        'start_page': 522,
        'end_page': 541,
      },
      {
        'juz_number': 28,
        'name_arabic': 'قَدْ سَمِعَ',
        'start_surah': 58,
        'start_ayah': 1,
        'end_surah': 66,
        'end_ayah': 12,
        'start_page': 542,
        'end_page': 561,
      },
      {
        'juz_number': 29,
        'name_arabic': 'تَبَارَكَ',
        'start_surah': 67,
        'start_ayah': 1,
        'end_surah': 77,
        'end_ayah': 50,
        'start_page': 562,
        'end_page': 581,
      },
      {
        'juz_number': 30,
        'name_arabic': 'عَمَّ يَتَسَاءَلُونَ',
        'start_surah': 78,
        'start_ayah': 1,
        'end_surah': 114,
        'end_ayah': 6,
        'start_page': 582,
        'end_page': 604,
      },
    ];

    final batch = db.batch();
    for (final j in juzData) {
      batch.insert('juz', j);
    }
    await batch.commit(noResult: true);
  }
}

void debugPrintStack({required String label}) {
  // Silent in release
  assert(() {
    // ignore: avoid_print
    print(label);
    return true;
  }());
}

final quranDbServiceProvider = Provider((_) => QuranDatabaseService());
