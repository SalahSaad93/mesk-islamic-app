import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Clay theme uses canvas background color #F4F1FA', (WidgetTester tester) async {
    const canvasColor = Color(0xFFF4F1FA);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: canvasColor,
        ),
        home: const Scaffold(),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, canvasColor);
  });
}
