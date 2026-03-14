import 'package:flutter/material.dart';

class ClayAnimationUtil {
  ClayAnimationUtil._();

  /// Returns true if animations should be enabled based on platform settings.
  /// Returns false if the user has enabled "reduce motion" accessibility settings.
  static bool shouldAnimate(BuildContext context) {
    return !MediaQuery.of(context).disableAnimations;
  }

  /// Returns an appropriate animation duration based on the reduce motion setting.
  /// If animations are disabled, returns Duration.zero.
  /// Otherwise, returns the provided duration.
  static Duration duration(
    BuildContext context,
    Duration normalDuration,
  ) {
    return shouldAnimate(context) ? normalDuration : Duration.zero;
  }

  /// Returns an appropriate animation curve based on the reduce motion setting.
  /// If animations are disabled, the curve is effectively linear (instant).
  /// Otherwise, returns the provided curve.
  static Curve curve(BuildContext context, Curve normalCurve) {
    return shouldAnimate(context) ? normalCurve : Curves.linear;
  }

  /// Returns an appropriate animation duration for tap/squish animations.
  static const Duration tapSquishDown = Duration(milliseconds: 100);
  static const Duration tapSquishUp = Duration(milliseconds: 150);

  /// Returns an appropriate animation duration for card lift animations.
  static const Duration cardLift = Duration(milliseconds: 100);
  static const Duration cardReturn = Duration(milliseconds: 150);

  /// Returns an appropriate animation duration for background blob drift.
  static const Duration blobDrift = Duration(seconds: 8);
}
