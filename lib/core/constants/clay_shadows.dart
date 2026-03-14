import 'package:flutter/material.dart';

enum ClayShadowLevel { surface, surfaceLite, button, pressed, navigation }

class ClayShadows {
  ClayShadows._();

  static List<BoxShadow> surface([bool isRtl = false]) => [
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.08),
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: -4,
    ),
    const BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.8),
      offset: Offset(0, -2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color.fromRGBO(124, 58, 237, 0.04).withValues(alpha: 0.5),
      offset: Offset(isRtl ? 4 : -4, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.02),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> surfaceLite([bool isRtl = false]) => [
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.06),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: -2,
    ),
    const BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.6),
      offset: Offset(0, -1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> button([bool isRtl = false]) => [
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.12),
      offset: Offset(0, 6),
      blurRadius: 20,
      spreadRadius: -2,
    ),
    const BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      offset: Offset(0, -2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color.fromRGBO(124, 58, 237, 0.06).withValues(alpha: 0.6),
      offset: Offset(isRtl ? 3 : -3, 0),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.03),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> pressed([bool isRtl = false]) => [
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.1),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.04),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> navigation([bool isRtl = false]) => [
    const BoxShadow(
      color: Color.fromRGBO(124, 58, 237, 0.04),
      offset: Offset(0, -2),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.7),
      offset: Offset(0, -1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color.fromRGBO(124, 58, 237, 0.02).withValues(alpha: 0.4),
      offset: Offset(isRtl ? 2 : -2, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> getShadowForLevel(
    ClayShadowLevel level, [
    bool isRtl = false,
  ]) {
    switch (level) {
      case ClayShadowLevel.surface:
        return surface(isRtl);
      case ClayShadowLevel.surfaceLite:
        return surfaceLite(isRtl);
      case ClayShadowLevel.button:
        return button(isRtl);
      case ClayShadowLevel.pressed:
        return pressed(isRtl);
      case ClayShadowLevel.navigation:
        return navigation(isRtl);
    }
  }
}
