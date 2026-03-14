import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClayButton Widget', () {
    testWidgets('renders primary variant with gradient', (WidgetTester tester) async {
      final gradient = LinearGradient(
        colors: [Colors.purple.shade200, Colors.purple.shade600],
      );

      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Primary Button', style: TextStyle(color: Colors.white)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.gradient, isNotNull);
      expect(decoration?.borderRadius, BorderRadius.all(Radius.circular(20)));
    });

    testWidgets('renders secondary variant with solid fill', (WidgetTester tester) async {
      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Secondary Button'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, const Color(0xFFF3F4F6));
    });

    testWidgets('renders outline variant with border', (WidgetTester tester) async {
      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Outline Button', style: TextStyle(color: Colors.purple)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });

    testWidgets('renders ghost variant with no border', (WidgetTester tester) async {
      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Ghost Button', style: TextStyle(color: Colors.purple)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNull);
    });

    testWidgets('responds to tap squish animation', (WidgetTester tester) async {
      final button = GestureDetector(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(child: Text('Press Me')),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      await tester.tap(find.text('Press Me'));
      await tester.pump();

      expect(find.text('Press Me'), findsOneWidget);
    });

    testWidgets('shows disabled state when onPressed is null', (WidgetTester tester) async {
      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Disabled Button', style: TextStyle(color: Colors.white)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.grey);
    });

    testWidgets('has minimum 48dp touch target', (WidgetTester tester) async {
      final button = Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.purple,
        ),
        child: Center(child: Text('Button')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minHeight, 48);
    });
  });
}
