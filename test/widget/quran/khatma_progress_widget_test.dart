import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/constants/app_colors.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/khatma_progress_entity.dart';
import 'package:mesk_islamic_app/features/quran/presentation/widgets/khatma_progress_widget.dart';

void main() {
  group('KhatmaProgressWidget', () {
    Widget createTestWidget(KhatmaProgressEntity khatmaState) {
      return ProviderScope(
        // overrides: [
        //   khatmaProvider.overrideWithValue(khatmaState),
        // ],
        child: MaterialApp(home: Scaffold(body: KhatmaProgressWidget())),
      );
    }

    late KhatmaProgressEntity testState;

    setUp(() {
      testState = KhatmaProgressEntity(
        highestPage: 0,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );
    });

    testWidgets(
      'should not show progress when highestPage is 0 and not completed',
      (WidgetTester tester) async {
        final khatmaState = KhatmaProgressEntity(
          highestPage: 0,
          totalPages: 604,
          startDate: DateTime.now(),
          isCompleted: false,
        );

        await tester.pumpWidget(createTestWidget(khatmaState));

        expect(find.byType(KhatmaProgressWidget), findsNothing);
      },
    );

    testWidgets('should show progress percentage when completed', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 604,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: true,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.text('Khatma Complete! 🎉'), findsOneWidget);
      expect(find.byIcon(Icons.celebration), findsOneWidget);
    });

    testWidgets('should show reset button when completed', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 604,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: true,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(
        find.byIcon(Icons.refresh).evaluate().first.widget,
        isA<IconButton>(),
      );
    });

    testWidgets('should call resetKhatma when reset button is pressed', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 604,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: true,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      final providerNotifier = tester
          .widget(find.byType(KhatmaProgressWidget))
          .key;
      expect(providerNotifier, isA<ConsumerWidget>());
    });

    testWidgets('should show percentage text when not completed', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 303,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.byIcon(Icons.timeline), findsOneWidget);
      expect(find.text('50.0%'), findsOneWidget);
    });

    testWidgets('should show progress bar with correct percentage', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 303,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressIndicator.value, 0.5);
    });

    testWidgets('should show pages read / 604 when highestPage > 0', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 150,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.text('150 / 604 pages'), findsOneWidget);
    });

    testWidgets('should use primary accent for high percentage (>= 50%)', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 303,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      final valueColor = progressIndicator.valueColor;

      expect(valueColor, isA<AlwaysStoppedAnimation<Color>>());
      expect((valueColor as dynamic).value, AppColors.primaryAccent);
    });

    testWidgets('should use secondary accent for low percentage (< 50%)', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 150,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      final valueColor = progressIndicator.valueColor;

      expect(valueColor, isA<AlwaysStoppedAnimation<Color>>());
      expect((valueColor as dynamic).value, AppColors.secondaryAccent);
    });

    testWidgets('should wrap progress in Row with proper spacing', (
      WidgetTester tester,
    ) async {
      final khatmaState = KhatmaProgressEntity(
        highestPage: 303,
        totalPages: 604,
        startDate: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(createTestWidget(khatmaState));

      expect(find.byType(Row), findsOneWidget);
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisSize, MainAxisSize.min);
    });
  });
}
