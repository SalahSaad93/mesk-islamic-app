import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('Clay theme uses Nunito for headings and DM Sans for body text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text(
                'Heading',
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Body',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    expect(textWidgets.length, 2);

    final headingText = textWidgets.elementAt(0);
    final bodyText = textWidgets.elementAt(1);

    expect(headingText.style?.fontFamily, contains('Nunito'));
    expect(headingText.style?.fontSize, 32);
    expect(headingText.style?.fontWeight, FontWeight.w900);

    expect(bodyText.style?.fontFamily, contains('DM Sans'));
    expect(bodyText.style?.fontSize, 16);
    expect(bodyText.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('Clay theme preserves Amiri font for Arabic text', (WidgetTester tester) async {
    const arabicText = 'بسم الله الرحمن الرحيم';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Text(
            arabicText,
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text(arabicText));
    expect(textWidget.style?.fontFamily, contains('Amiri'));
    expect(textWidget.style?.fontSize, 22);
  });
}
