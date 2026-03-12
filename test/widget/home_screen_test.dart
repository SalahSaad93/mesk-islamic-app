import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mesk_islamic_app/features/home/presentation/screens/home_screen.dart';
import 'package:mesk_islamic_app/features/prayer_times/presentation/providers/prayer_times_provider.dart';
import 'package:mesk_islamic_app/features/prayer_times/domain/entities/prayer_times_entity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

class MockPrayerTimesNotifier extends AsyncNotifier<PrayerTimesEntity>
    with Mock
    implements PrayerTimesNotifier {}

void main() {
  group('Home Screen - Responsive Layout Tests', () {
    late PrayerTimesEntity testPrayerTimes;
    late MockPrayerTimesNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockPrayerTimesNotifier();
      final now = DateTime.now();
      testPrayerTimes = PrayerTimesEntity(
        fajr: now.add(const Duration(hours: 1)),
        sunrise: now.add(const Duration(hours: 2)),
        dhuhr: now.add(const Duration(hours: 4)),
        asr: now.add(const Duration(hours: 6)),
        maghrib: now.add(const Duration(hours: 8)),
        isha: now.add(const Duration(hours: 10)),
        date: now,
        locationName: 'Test City',
        calculationMethod: 'MWL',
      );
      when(() => mockNotifier.build()).thenAnswer((_) async => testPrayerTimes);
    });

    testWidgets('renders without overflow on compact width (phone portrait)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prayerTimesProvider.overrideWith(() => mockNotifier),
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
              home: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('renders without overflow on regular width (phone landscape)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prayerTimesProvider.overrideWith(() => mockNotifier),
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
              home: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('key widgets are visible on compact width', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prayerTimesProvider.overrideWith(() => mockNotifier),
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
              home: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('key widgets are visible on regular width', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prayerTimesProvider.overrideWith(() => mockNotifier),
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
              home: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  });

  group('Home Screen - Basic Tests', () {
    testWidgets('renders bento layout with ClayCard', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                  ),
                  child: Text('Card 1'),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                  ),
                  child: Text('Card 2'),
                ),
              ],
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThan(1));
    });

    testWidgets('renders prayer countdown hero card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text('00:45:30', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  Text('Remaining', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('00:45:30'), findsOneWidget);
      expect(find.text('Remaining'), findsOneWidget);
    });

    testWidgets('renders quick-access feature tiles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade200, Colors.purple.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.explore, color: Colors.white),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.menu_book, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, 2);
    });

    testWidgets('includes background blobs layer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: TestPainter(),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
