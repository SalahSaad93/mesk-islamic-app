import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesk_islamic_app/app.dart';
import 'package:mesk_islamic_app/core/services/storage_service.dart';
import 'package:mesk_islamic_app/core/services/notification_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockNotificationService extends Mock implements NotificationService {}
class TimeOfDayFake extends Fake implements TimeOfDay {}

void main() {
  setUpAll(() {
    registerFallbackValue(TimeOfDayFake());
  });

  testWidgets('App should default to Arabic on first launch', (WidgetTester tester) async {
    final mockPrefs = MockSharedPreferences();
    final mockNotif = MockNotificationService();
    
    // Arrange: No language stored
    when(() => mockPrefs.getString('language')).thenReturn(null);
    when(() => mockPrefs.getBool('isDarkMode')).thenReturn(false);
    when(() => mockPrefs.getString('calculationMethod')).thenReturn('ISNA');
    when(() => mockNotif.requestPermissions()).thenAnswer((_) async {});
    when(() => mockNotif.scheduleAthkarReminder(
          id: any(named: 'id'),
          category: any(named: 'category'),
          timeOfDay: any(named: 'timeOfDay'),
        )).thenAnswer((_) async {});
    when(() => mockNotif.scheduleDailyVerseNotification(
          id: any(named: 'id'),
          timeOfDay: any(named: 'timeOfDay'),
        )).thenAnswer((_) async {});
    
    final storageService = StorageService(mockPrefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          notificationServiceProvider.overrideWithValue(mockNotif),
        ],
        child: const MeskApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Try finding the text. If it fails, it will throw an error which is fine for "expected fail"
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
