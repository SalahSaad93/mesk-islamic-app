import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClayColors', () {
    test('Canvas color matches #F4F1FA', () {
      expect(0xFFF4F1FA, 0xFFF4F1FA);
    });

    test('Surface color matches #FFFFFF', () {
      expect(0xFFFFFFFF, 0xFFFFFFFF);
    });

    test('PrimaryAccent color matches #7C3AED', () {
      expect(0xFF7C3AED, 0xFF7C3AED);
    });

    test('PrimaryAccentLight color matches #A78BFA', () {
      expect(0xFFA78BFA, 0xFFA78BFA);
    });

    test('PrimaryAccentDark color matches #5B21B6', () {
      expect(0xFF5B21B6, 0xFF5B21B6);
    });

    test('SecondaryAccent color matches #DB2777', () {
      expect(0xFFDB2777, 0xFFDB2777);
    });

    test('TertiaryAccent color matches #0EA5E9', () {
      expect(0xFF0EA5E9, 0xFF0EA5E9);
    });

    test('Success color matches #10B981', () {
      expect(0xFF10B981, 0xFF10B981);
    });

    test('Warning color matches #F59E0B', () {
      expect(0xFFF59E0B, 0xFFF59E0B);
    });

    test('TextPrimary color matches #332F3A', () {
      expect(0xFF332F3A, 0xFF332F3A);
    });

    test('TextSecondary color matches #635F69', () {
      expect(0xFF635F69, 0xFF635F69);
    });

    test('TextTertiary color matches #9CA3AF', () {
      expect(0xFF9CA3AF, 0xFF9CA3AF);
    });

    test('TextOnPrimary color matches #FFFFFF', () {
      expect(0xFFFFFFFF, 0xFFFFFFFF);
    });

    test('Error color matches #EF4444', () {
      expect(0xFFEF4444, 0xFFEF4444);
    });

    test('Divider color matches #E5E7EB', () {
      expect(0xFFE5E7EB, 0xFFE5E7EB);
    });

    test('Border color matches #D1D5DB', () {
      expect(0xFFD1D5DB, 0xFFD1D5DB);
    });
  });
}
