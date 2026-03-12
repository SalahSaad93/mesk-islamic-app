import 'package:flutter/material.dart';

/// Simple size class definitions for responsive layouts.
enum ResponsiveSizeClass {
  /// Compact width (e.g., typical phone in portrait)
  compact,

  /// Regular width (e.g., phone in landscape or small tablet portrait)
  regular,

  /// Wide/Expanded width (e.g., large phone landscape or tablet)
  expanded,
}

/// Utility helpers to derive size class and orientation from MediaQuery.
class ResponsiveLayout {
  ResponsiveLayout._();

  /// Width threshold for compact (typical phone portrait)
  static const double _compactWidthThreshold = 600;

  /// Width threshold for regular (phone landscape / small tablet)
  static const double _regularWidthThreshold = 900;

  /// Determine size class from MediaQuery width.
  static ResponsiveSizeClass fromWidth(double width) {
    if (width < _compactWidthThreshold) {
      return ResponsiveSizeClass.compact;
    } else if (width < _regularWidthThreshold) {
      return ResponsiveSizeClass.regular;
    } else {
      return ResponsiveSizeClass.expanded;
    }
  }

  /// Determine size class from current MediaQuery.
  static ResponsiveSizeClass fromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return fromWidth(width);
  }

  /// Determine if orientation is landscape (width > height)
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }
}
