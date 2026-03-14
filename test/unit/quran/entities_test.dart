import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/note_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/highlight_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/bookmark_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reciter_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/verse_position_entity.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/khatma_progress_entity.dart';

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

    test('VersePositionEntity construction', () {
      final position = VersePositionEntity(
        surahNumber: 1,
        ayahNumber: 1,
        page: 1,
      );

      expect(position.surahNumber, 1);
      expect(position.ayahNumber, 1);
      expect(position.page, 1);
    });

    test('VersePositionEntity fromMap/toMap mapping', () {
      final position = VersePositionEntity(
        surahNumber: 2,
        ayahNumber: 255,
        page: 30,
      );

      final map = position.toMap();
      expect(map['surah_number'], 2);
      expect(map['ayah_number'], 255);
      expect(map['page'], 30);

      final fromMap = VersePositionEntity.fromMap(map);
      expect(fromMap.surahNumber, position.surahNumber);
      expect(fromMap.ayahNumber, position.ayahNumber);
      expect(fromMap.page, position.page);
    });

    test('VersePositionEntity equality', () {
      final position1 = VersePositionEntity(
        surahNumber: 1,
        ayahNumber: 1,
        page: 1,
      );
      final position2 = VersePositionEntity(
        surahNumber: 1,
        ayahNumber: 1,
        page: 1,
      );
      final position3 = VersePositionEntity(
        surahNumber: 1,
        ayahNumber: 2,
        page: 1,
      );

      expect(position1, equals(position2));
      expect(position1, isNot(equals(position3)));
    });

    test('KhatmaProgressEntity percentage calculation', () {
      final progress = KhatmaProgressEntity(
        highestPage: 302,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      expect(progress.percentage, closeTo(50.0, 0.1));
    });

    test('KhatmaProgressEntity percentage is 0 when totalPages is 0', () {
      final progress = KhatmaProgressEntity(
        highestPage: 100,
        totalPages: 0,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      expect(progress.percentage, 0.0);
    });

    test('KhatmaProgressEntity copyWith', () {
      final progress = KhatmaProgressEntity(
        highestPage: 100,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      final updated = progress.copyWith(highestPage: 200, isCompleted: true);

      expect(updated.highestPage, 200);
      expect(updated.isCompleted, true);
      expect(updated.totalPages, 604);
    });
  });
}
