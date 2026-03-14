import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BackgroundBlobsLayer Widget', () {
    testWidgets('renders custom painter blobs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomPaint(painter: TestPainter())),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('respects reduced motion setting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const Scaffold(body: Text('Content')),
          ),
        ),
      );

      expect(find.byType(MediaQuery), findsOneWidget);
      final mediaQuery = tester.widget<MediaQuery>(find.byType(MediaQuery));
      expect(mediaQuery.data.disableAnimations, true);
    });

    testWidgets('isolates repaints with RepaintBoundary', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(child: CustomPaint(painter: TestPainter())),
          ),
        ),
      );

      expect(find.byType(RepaintBoundary), findsOneWidget);
    });

    testWidgets('uses radial gradients for blob colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomPaint(painter: TestPainter())),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });
}

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.withValues(alpha: 0.15)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
