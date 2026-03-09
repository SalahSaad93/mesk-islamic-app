import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/surah_entity.dart';

class QuranLocalDatasource {
  List<SurahEntity>? _surahsCache;

  Future<List<SurahEntity>> getSurahs() async {
    if (_surahsCache != null) return _surahsCache!;
    final jsonStr = await rootBundle.loadString('assets/data/surahs.json');
    final List<dynamic> data = json.decode(jsonStr);
    _surahsCache = data.map((e) => SurahEntity.fromJson(e)).toList();
    return _surahsCache!;
  }

  SurahEntity? getSurahForPage(List<SurahEntity> surahs, int page) {
    SurahEntity? result;
    for (final surah in surahs) {
      if (surah.startPage <= page && page <= surah.endPage) {
        result = surah;
      }
    }
    return result;
  }
}
