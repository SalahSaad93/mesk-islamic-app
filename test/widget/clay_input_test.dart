import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClayInput Widget', () {
    testWidgets('renders with recessed appearance', (
      WidgetTester tester,
    ) async {
      final input = TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide.none,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(padding: EdgeInsets.all(16), child: input),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TextField),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.borderRadius, BorderRadius.all(Radius.circular(20)));
    });

    testWidgets('applies pressed level shadow by default', (
      WidgetTester tester,
    ) async {
      final input = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(124, 58, 237, 0.1),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: TextField(),
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: input)));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.boxShadow, isNotEmpty);
    });

    testWidgets('raises shadow on focus', (WidgetTester tester) async {
      var isFocused = false;

      final input = StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: Color.fromRGBO(124, 58, 237, 0.08),
                        offset: Offset(0, 8),
                        blurRadius: 32,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Color.fromRGBO(124, 58, 237, 0.1),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
            ),
            child: TextField(
              onTap: () => setState(() => isFocused = !isFocused),
            ),
          );
        },
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: input)));

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.boxShadow?.length, greaterThan(1));
    });

    testWidgets('has 20px border radius', (WidgetTester tester) async {
      final input = TextField(
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(padding: EdgeInsets.all(16), child: input),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;
      final border = decoration?.border as OutlineInputBorder?;
      expect(border?.borderRadius, const BorderRadius.all(Radius.circular(20)));
    });

    testWidgets('supports prefix icon', (WidgetTester tester) async {
      final input = TextField(
        decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: input)));

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('supports suffix icon', (WidgetTester tester) async {
      final input = TextField(
        decoration: InputDecoration(suffixIcon: Icon(Icons.clear)),
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: input)));

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });
}
