import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/constants/app_colors.dart';
import 'package:mesk_islamic_app/features/quran/presentation/screens/quran_verse_mode_screen.dart';

void main() {
  group('QuranVerseModeScreen Navigation', () {
    Widget createTestScreen() {
      return ProviderScope(
        overrides: [
          // quranAudioProvider.overrideWithValue(
          //   const QuranAudioState(isPlaying: false),
          // ),
        ],
        child: MaterialApp(home: const QuranVerseModeScreen()),
      );
    }

    testWidgets('should start with page 0 on initial load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byType(QuranVerseModeScreen), findsOneWidget);
    });

    testWidgets('should display correct surah and ayah numbers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.text('Surah 1'), findsOneWidget);
      expect(find.text('Ayah 1'), findsOneWidget);
    });

    testWidgets('should display bottom navigation controls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byIcon(Icons.skip_previous_outlined), findsOneWidget);
      expect(find.byIcon(Icons.skip_next_outlined), findsOneWidget);
    });

    testWidgets('should have top bar with back button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('should display translation toggle button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byIcon(Icons.translate), findsOneWidget);
    });

    testWidgets('should display verse information in top bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.text('Surah 1'), findsOneWidget);
      expect(find.text('Ayah 1'), findsOneWidget);
    });

    testWidgets('should have proper background color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.surface);
    });

    testWidgets('should display safe area for bottom controls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have proper spacing in layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestScreen());

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
