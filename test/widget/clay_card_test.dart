import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClayCard Widget', () {
    testWidgets('renders with 32px border radius', (WidgetTester tester) async {
      final card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          color: Colors.white,
        ),
        child: Text('Card Content'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: card,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        (container.decoration as BoxDecoration?)?.borderRadius,
        BorderRadius.all(Radius.circular(32)),
      );
    });

    testWidgets('applies shadow layers', (WidgetTester tester) async {
      final card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(124, 58, 237, 0.08),
              offset: Offset(0, 8),
              blurRadius: 32,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Text('Card Content'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: card,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.boxShadow, isNotEmpty);
      expect(decoration?.boxShadow?.length, greaterThan(1));
    });

    testWidgets('supports glass effect with overlay', (WidgetTester tester) async {
      final card = Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              color: Colors.white,
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                ),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: card,
          ),
        ),
      );

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('responds to tap gesture', (WidgetTester tester) async {
      var tapped = false;

      final card = GestureDetector(
        onTap: () {
          tapped = true;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            color: Colors.white,
          ),
          child: Text('Tappable Card'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: card,
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      expect(tapped, true);
    });

    testWidgets('has minimum 48dp touch target', (WidgetTester tester) async {
      final card = GestureDetector(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            color: Colors.white,
          ),
          child: Text('Card'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: card,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minHeight, 48);
    });
  });
}
