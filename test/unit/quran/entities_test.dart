import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/note_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/highlight_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/bookmark_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reciter_entity.dart';

void main() {
  group('Quran Entities Unit Tests', () {
    test('NoteEntity fromMap/toMap mapping', () {
      final now = DateTime.now();
      final note = NoteEntity(
        id: '1',
        verseId: 101,
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatiha',
        text: 'Test Note',
        createdAt: now,
        updatedAt: now,
      );

      final map = note.toMap();
      expect(map['id'], '1');
      expect(map['text'], 'Test Note');

      final fromMap = NoteEntity.fromMap(map);
      expect(fromMap.text, note.text);
      expect(fromMap.createdAt.toIso8601String(), note.createdAt.toIso8601String());
    });

    test('HighlightEntity fromMap/toMap mapping', () {
      final now = DateTime.now();
      final highlight = HighlightEntity(
        id: '1',
        verseId: 101,
        surahNumber: 1,
        ayahNumber: 1,
        color: '#FF0000',
        createdAt: now,
      );

      final map = highlight.toMap();
      expect(map['color'], '#FF0000');

      final fromMap = HighlightEntity.fromMap(map);
      expect(fromMap.color, highlight.color);
    });

    test('BookmarkEntity fromMap/toMap mapping', () {
      final now = DateTime.now();
      final bookmark = BookmarkEntity(
        id: '1',
        verseId: 101,
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatiha',
        title: 'My Bookmark',
        createdAt: now,
      );

      final map = bookmark.toMap();
      expect(map['title'], 'My Bookmark');

      final fromMap = BookmarkEntity.fromMap(map);
      expect(fromMap.title, bookmark.title);
    });

    test('ReciterEntity fromJson/toJson mapping', () {
      final reciter = ReciterEntity(
        id: 'alafasy',
        nameArabic: 'العفاسي',
        nameEnglish: 'Alafasy',
        style: 'Murattal',
        audioBaseUrl: 'http://example.com/',
      );

      final json = reciter.toJson();
      expect(json['id'], 'alafasy');

      final fromJson = ReciterEntity.fromJson(json);
      expect(fromJson.nameEnglish, reciter.nameEnglish);
    });
  });
}
