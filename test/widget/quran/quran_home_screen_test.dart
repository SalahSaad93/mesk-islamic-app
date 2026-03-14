import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesk_islamic_app/features/quran/presentation/screens/quran_home_screen.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/surah_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/providers/quran_provider.dart';
import 'package:mesk_islamic_app/features/quran/presentation/widgets/reading_mode_toggle.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reading_preferences_entity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

void main() {
  group('Quran Home Screen - Responsive Layout Tests', () {
    late List<SurahEntity> testSurahs;

    setUp(() {
      testSurahs = [
        SurahEntity(
          number: 1,
          nameArabic: 'الفاتحة',
          nameEnglish: 'Al-Fatiha',
          revelationType: 'Meccan',
          versesCount: 7,
          startPage: 1,
          endPage: 1,
          juzNumber: 1,
        ),
        SurahEntity(
          number: 2,
          nameArabic: 'البقرة',
          nameEnglish: 'Al-Baqarah',
          revelationType: 'Medinan',
          versesCount: 286,
          startPage: 2,
          endPage: 49,
          juzNumber: 1,
        ),
        SurahEntity(
          number: 3,
          nameArabic: 'آل عمران',
          nameEnglish: 'Aali Imran',
          revelationType: 'Medinan',
          versesCount: 200,
          startPage: 50,
          endPage: 77,
          juzNumber: 3,
        ),
      ];
    });

    testWidgets('renders without overflow on compact width (phone portrait)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('renders without overflow on regular width (phone landscape)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(667, 375)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('key widgets are visible on compact width', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(360, 640)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('key widgets are visible on regular width', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(768, 1024)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('renders without overflow on tablet landscape (1024x768)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(1024, 768)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('renders without overflow on wide layout (1366x768)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(1366, 768)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(QuranHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('should display ReadingModeToggle widget', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ReadingModeToggle), findsOneWidget);
    });

    testWidgets('should display Continue Reading button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Continue Reading (Mushaf)'), findsOneWidget);
    });

    testWidgets('should display both Mushaf and Verse mode options in toggle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Mushaf'), findsOneWidget);
      expect(find.text('Verse'), findsOneWidget);
    });

    testWidgets('ReadingModeToggle should be tappable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            surahsProvider.overrideWith((ref) async => testSurahs),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 667)),
            child: MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en'), Locale('ar')],
              home: QuranHomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Verse'));
      await tester.pumpAndSettle();

      expect(find.text('Continue Reading (Verse)'), findsOneWidget);
    });
  });
}
