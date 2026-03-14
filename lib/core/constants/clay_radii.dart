import 'package:flutter/material.dart';

class ClayRadii {
  ClayRadii._();

  static const double containerLarge = 48.0;
  static const double containerLargeMax = 60.0;
  static const double card = 32.0;
  static const double medium = 24.0;
  static const double button = 20.0;
  static const double icon = 16.0;
  static const double iconCircular = 16.0;
  static const double badge = 8.0;

  static BorderRadius get containerLargeRadius => BorderRadius.circular(containerLarge);
  static BorderRadius get containerLargeMaxRadius => BorderRadius.circular(containerLargeMax);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get iconRadius => BorderRadius.circular(icon);
  static BorderRadius get iconCircularRadius => BorderRadius.circular(iconCircular);
  static BorderRadius get badgeRadius => BorderRadius.circular(badge);
}
