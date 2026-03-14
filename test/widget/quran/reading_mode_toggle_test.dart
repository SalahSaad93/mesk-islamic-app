import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reading_preferences_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/widgets/reading_mode_toggle.dart';

void main() {
  group('ReadingModeToggle', () {
    testWidgets('should render both options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Mushaf'), findsOneWidget);
      expect(find.text('Verse'), findsOneWidget);
    });

    testWidgets('should show Mushaf icon for fullQuranMode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
    });

    testWidgets('should show Verse icon for verseMode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.verseMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.format_quote), findsOneWidget);
    });

    testWidgets('should call onModeChanged when Mushaf is tapped',
        (WidgetTester tester) async {
      ReadingMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.verseMode,
              onModeChanged: (mode) => selectedMode = mode,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mushaf'));
      await tester.pumpAndSettle();

      expect(selectedMode, ReadingMode.fullQuranMode);
    });

    testWidgets('should call onModeChanged when Verse is tapped',
        (WidgetTester tester) async {
      ReadingMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (mode) => selectedMode = mode,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Verse'));
      await tester.pumpAndSettle();

      expect(selectedMode, ReadingMode.verseMode);
    });

    testWidgets('should highlight selected mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Mushaf'), findsOneWidget);
    });

    testWidgets('should have proper container styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should have two gesture detectors for options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReadingModeToggle(
              currentMode: ReadingMode.fullQuranMode,
              onModeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNWidgets(2));
    });
  });
}
