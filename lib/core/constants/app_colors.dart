import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Clay Design System Colors

  // Canvas & Background
  static const Color canvas = Color(0xFFF4F1FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Primary Accents (Violet)
  static const Color primaryAccent = Color(0xFF7C3AED);
  static const Color primaryAccentLight = Color(0xFFA78BFA);
  static const Color primaryAccentDark = Color(0xFF5B21B6);

  // Secondary & Tertiary Accents
  static const Color secondaryAccent = Color(0xFFDB2777);
  static const Color tertiaryAccent = Color(0xFF0EA5E9);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF332F3A);
  static const Color textSecondary = Color(0xFF635F69);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  // Shadow & Highlight Colors
  static const Color shadowColor = Color.fromRGBO(124, 58, 237, 0.08);
  static const Color highlightColor = Color.fromRGBO(255, 255, 255, 0.8);

  // Legacy Aliases (for backward compatibility - will be deprecated)
  @Deprecated('Use primaryAccent instead')
  static const Color primaryGreen = primaryAccent;
  @Deprecated('Use primaryAccentLight instead')
  static const Color primaryGreenLight = primaryAccentLight;
  @Deprecated('Use primaryAccentDark instead')
  static const Color primaryGreenDark = primaryAccentDark;
  @Deprecated('Use canvas instead')
  static const Color backgroundLight = canvas;
  @Deprecated('Use surface instead')
  static const Color backgroundWhite = surface;
  @Deprecated('Use surface instead')
  static const Color cardBackground = surface;
  @Deprecated('Use warning instead')
  static const Color goldAccent = warning;
  @Deprecated('Use canvas instead')
  static const Color goldLight = Color(0xFFFFF3CD);
  @Deprecated('Use textPrimary instead')
  static const Color textDark = textPrimary;
  @Deprecated('Use textSecondary instead')
  static const Color textMedium = textSecondary;
  @Deprecated('Use textTertiary instead')
  static const Color textLight = textTertiary;
  @Deprecated('Use textOnPrimary instead')
  static const Color textWhite = textOnPrimary;

  // Prayer status colors (mapped to clay palette)
  static const Color prayerActive = primaryAccent;
  static const Color prayerPast = Color(0xFFB0B0C0);
  static const Color prayerUpcoming = primaryAccentLight;

  // Legacy shadow color (for backward compatibility)
  @Deprecated('Use shadowColor instead')
  static const Color shadow = Color(0x1A000000);

  // Notification badge (keeps error color)
  static const Color notificationBadge = error;
}
