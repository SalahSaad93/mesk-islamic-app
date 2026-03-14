import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/reciter_entity.dart';

class ReciterDatasource {
  Future<List<ReciterEntity>> getReciters() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/reciters.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((j) => ReciterEntity.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return a basic list if asset loading fails for some reason
      return const [
        ReciterEntity(
          id: 'ar.alafasy',
          nameArabic: 'مشاري راشد العفاسي',
          nameEnglish: 'Mishary Rashid Alafasy',
          style: 'Murattal',
          audioBaseUrl: 'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/',
        ),
      ];
    }
  }
}
