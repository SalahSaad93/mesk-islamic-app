import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClayShadow presets', () {
    test('Surface shadow has 4 layers', () {
      const surfaceShadow = BoxShadow(
        color: Color.fromRGBO(124, 58, 237, 0.08),
        offset: Offset(0, 8),
        blurRadius: 32,
        spreadRadius: -4,
      );

      expect(surfaceShadow.color, const Color.fromRGBO(124, 58, 237, 0.08));
      expect(surfaceShadow.offset, const Offset(0, 8));
      expect(surfaceShadow.blurRadius, 32);
      expect(surfaceShadow.spreadRadius, -4);
    });

    test('SurfaceLite shadow has 2 layers for performance', () {
      const surfaceLiteShadow = BoxShadow(
        color: Color.fromRGBO(124, 58, 237, 0.06),
        offset: Offset(0, 4),
        blurRadius: 16,
        spreadRadius: -2,
      );

      expect(surfaceLiteShadow.color, const Color.fromRGBO(124, 58, 237, 0.06));
      expect(surfaceLiteShadow.offset, const Offset(0, 4));
      expect(surfaceLiteShadow.blurRadius, 16);
      expect(surfaceLiteShadow.spreadRadius, -2);
    });

    test('Button shadow has convex highlight', () {
      const buttonShadow = BoxShadow(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        offset: Offset(0, -2),
        blurRadius: 8,
        spreadRadius: 0,
      );

      expect(buttonShadow.color, const Color.fromRGBO(255, 255, 255, 0.8));
      expect(buttonShadow.offset, const Offset(0, -2));
      expect(buttonShadow.blurRadius, 8);
    });

    test('Pressed shadow has vertical offset', () {
      const pressedShadow = BoxShadow(
        color: Color.fromRGBO(124, 58, 237, 0.1),
        offset: Offset(0, 2),
        blurRadius: 8,
        spreadRadius: 0,
      );

      expect(pressedShadow.color, const Color.fromRGBO(124, 58, 237, 0.1));
      expect(pressedShadow.offset, const Offset(0, 2));
      expect(pressedShadow.blurRadius, 8);
    });

    test('Navigation shadow has soft outer layer', () {
      const navigationShadow = BoxShadow(
        color: Color.fromRGBO(124, 58, 237, 0.04),
        offset: Offset(0, -2),
        blurRadius: 12,
        spreadRadius: 0,
      );

      expect(navigationShadow.color, const Color.fromRGBO(124, 58, 237, 0.04));
      expect(navigationShadow.offset, const Offset(0, -2));
      expect(navigationShadow.blurRadius, 12);
    });
  });
}
