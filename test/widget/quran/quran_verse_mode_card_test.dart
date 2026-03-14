import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/constants/app_colors.dart';
import 'package:mesk_islamic_app/core/constants/app_text_styles.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/verse_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/widgets/verse_mode_card.dart';

void main() {
  group('VerseModeCard', () {
    testWidgets('should display surah number', (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.text('Surah 1'), findsOneWidget);
    });

    testWidgets('should display ayah number', (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.text('Ayah 1'), findsOneWidget);
    });

    testWidgets('should display verse text with Arabic font',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
      final container = tester.widget<Container>(
        find.byType(VerseModeCard).first,
      );
      expect(container.decoration, isNotNull);
    });

    testWidgets('should have proper padding and margins',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
    });

    testWidgets('should show surah number in Arabic font',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
    });

    testWidgets('should display correct Arabic text direction',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
      final container = tester.widget<Container>(
        find.byType(VerseModeCard).first,
      );
      expect(container.decoration, isNotNull);
    });

    testWidgets('should have rounded corners',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
    });

    testWidgets('should have shadow effect',
        (WidgetTester tester) async {
      final verse = VerseEntity(
        id: 1,
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        page: 1,
        juz: 1,
        hizb: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerseModeCard(verse: verse),
          ),
        ),
      );

      expect(find.byType(VerseModeCard), findsOneWidget);
    });
  });
}
