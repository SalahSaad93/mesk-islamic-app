import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/thikr_entity.dart';

class AthkarLocalDatasource {
  List<ThikrEntity>? _morningCache;
  List<ThikrEntity>? _eveningCache;

  Future<List<ThikrEntity>> getMorningAthkar() async {
    if (_morningCache != null) return _morningCache!;
    final jsonStr =
        await rootBundle.loadString('assets/data/athkar_morning.json');
    final List<dynamic> data = json.decode(jsonStr);
    _morningCache = data.map((e) => _fromJson(e)).toList();
    return _morningCache!;
  }

  Future<List<ThikrEntity>> getEveningAthkar() async {
    if (_eveningCache != null) return _eveningCache!;
    final jsonStr =
        await rootBundle.loadString('assets/data/athkar_evening.json');
    final List<dynamic> data = json.decode(jsonStr);
    _eveningCache = data.map((e) => _fromJson(e)).toList();
    return _eveningCache!;
  }

  ThikrEntity _fromJson(Map<String, dynamic> json) {
    return ThikrEntity(
      id: json['id'] as int,
      arabic: json['arabic'] as String,
      translation: json['translation'] as String,
      transliteration: json['transliteration'] as String,
      source: json['source'] as String,
      repeatCount: json['repeatCount'] as int,
      category: json['category'] as String,
      reference: json['reference'] as String,
    );
  }
}
