import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/athkar/presentation/screens/athkar_home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

void main() {
  group('Athkar Home Screen - Responsive Layout Tests', () {
    testWidgets('renders without overflow on compact width (phone portrait)', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(375, 667)),
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            home: AthkarHomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AthkarHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('renders without overflow on regular width (phone landscape)', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(667, 375)),
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            home: AthkarHomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AthkarHomeScreen), findsOneWidget);

      final overflowWidgets = tester.widgetList<OverflowBox>(find.byType(OverflowBox));
      expect(overflowWidgets.length, 0);
    });

    testWidgets('key widgets are visible on compact width', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(360, 640)),
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            home: AthkarHomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AthkarHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('Athkar & Duas'), findsOneWidget);
    });

    testWidgets('key widgets are visible on regular width', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(768, 1024)),
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            home: AthkarHomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AthkarHomeScreen), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  });
}
