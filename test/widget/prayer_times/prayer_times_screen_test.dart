import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mesk_islamic_app/features/prayer_times/presentation/screens/prayer_times_screen.dart';
import 'package:mesk_islamic_app/features/prayer_times/presentation/providers/prayer_times_provider.dart';
import 'package:mesk_islamic_app/features/prayer_times/domain/entities/prayer_times_entity.dart';
import 'package:mesk_islamic_app/core/services/location_service.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';
import 'package:mesk_islamic_app/core/services/notification_service.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockPrayerTimesNotifier extends AsyncNotifier<PrayerTimesEntity>
    with Mock
    implements PrayerTimesNotifier {}

class MockLocationService extends Mock implements LocationService {}
class MockStorageService extends Mock implements StorageService {}
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('PrayerTimesScreen - Responsive Layout Tests', () {
    late PrayerTimesEntity testEntity;
    late MockPrayerTimesNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockPrayerTimesNotifier();
      testEntity = PrayerTimesEntity(
        fajr: DateTime.now().add(const Duration(hours: 1)),
        sunrise: DateTime.now().add(const Duration(hours: 2)),
        dhuhr: DateTime.now().add(const Duration(hours: 4)),
        asr: DateTime.now().add(const Duration(hours: 6)),
        maghrib: DateTime.now().add(const Duration(hours: 8)),
        isha: DateTime.now().add(const Duration(hours: 10)),
        date: DateTime.now(),
        locationName: 'Test City',
        calculationMethod: 'MWL',
      );
      when(() => mockNotifier.build()).thenAnswer((_) async => testEntity);
    });

    testWidgets('renders without overflow on compact width (phone portrait)', (tester) async {
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
              home: PrayerTimesScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PrayerTimesScreen), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('renders without overflow on regular width (phone landscape)', (tester) async {
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
              home: PrayerTimesScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PrayerTimesScreen), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('key sections visible on compact width', (tester) async {
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
              home: PrayerTimesScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PrayerTimesScreen), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });

  group('PrayerTimesScreen - Basic Tests', () {
    late PrayerTimesEntity testEntity;

    setUp(() {
      testEntity = PrayerTimesEntity(
        fajr: DateTime.now().add(const Duration(hours: 1)),
        sunrise: DateTime.now().add(const Duration(hours: 2)),
        dhuhr: DateTime.now().add(const Duration(hours: 4)),
        asr: DateTime.now().add(const Duration(hours: 6)),
        maghrib: DateTime.now().add(const Duration(hours: 8)),
        isha: DateTime.now().add(const Duration(hours: 10)),
        date: DateTime.now(),
        locationName: 'Test City',
        calculationMethod: 'MWL',
      );
    });

    testWidgets('PrayerTimesScreen shows RefreshIndicator and calls refresh', (tester) async {
      final mockNotifier = MockPrayerTimesNotifier();
      
      // Setup mockNotifier behavior
      when(() => mockNotifier.build()).thenAnswer((_) async => testEntity);
      when(() => mockNotifier.refresh()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prayerTimesProvider.overrideWith(() => mockNotifier),
            // Need to override dependencies for the mock notifier if it uses them in build
            // but since we mocked build, we might be fine.
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            locale: Locale('ar'),
            home: PrayerTimesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Trigger pull-to-refresh
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 500));
      await tester.pump(); // Start the refresh
      await tester.pump(const Duration(seconds: 1)); // Wait for animation

      verify(() => mockNotifier.refresh()).called(1);
    });
  });
}
