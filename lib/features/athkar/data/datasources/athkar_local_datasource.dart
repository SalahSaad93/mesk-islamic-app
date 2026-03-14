import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/thikr_entity.dart';

class AthkarLocalDatasource {
  final Map<String, List<ThikrEntity>> _cache = {};

  Future<List<ThikrEntity>> getAthkarByCategory(String category) async {
    if (_cache.containsKey(category)) return _cache[category]!;

    final assetPath = 'assets/data/athkar_$category.json';
    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(jsonStr);
      final result = data.map((e) => _fromJson(e)).toList();
      _cache[category] = result;
      return result;
    } catch (e) {
      return []; // Return empty list if file not found or parsing fails
    }
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
