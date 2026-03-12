import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyVerse {
  final String arabicText;
  final String translation;
  final String reference;

  const DailyVerse({
    required this.arabicText,
    required this.translation,
    required this.reference,
  });
}

class DailyVerseHelper {
  static List<DailyVerse> _verses = _staticVerses;

  static const List<DailyVerse> _staticVerses = [
    DailyVerse(
      arabicText: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
      translation:
          '"And whoever fears Allah - He will make for him a way out."',
      reference: 'Quran 65:2',
    ),
    // ... same as before but keeping as fallback
  ];

  static Future<void> loadFromAssets() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/daily_verses.json');
      final data = await json.decode(response) as List;
      _verses = data.map((e) => DailyVerse(
        arabicText: e['text'],
        translation: e['translation'],
        reference: 'Quran ${e['surah']}:${e['ayah']}',
      )).toList();
    } catch (e) {
      // Fallback to static verses
      _verses = _staticVerses;
    }
  }

  static DailyVerse getTodayVerse() {
    final now = DateTime.now();
    final dayOfYear = now.year * 1000 + now.month * 100 + now.day;
    final index = dayOfYear % (_verses.isEmpty ? 1 : _verses.length);
    return _verses[index];
  }
}

final dailyVerseProvider = FutureProvider<DailyVerse>((ref) async {
  await DailyVerseHelper.loadFromAssets();
  return DailyVerseHelper.getTodayVerse();
});
