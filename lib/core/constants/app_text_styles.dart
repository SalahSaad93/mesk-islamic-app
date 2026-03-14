import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Arabic text styles (offline - expects an Arabic font family declared in pubspec)
  static const TextStyle arabicHeading = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.8,
  );

  static const TextStyle arabicBody = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 2.0,
  );

  static const TextStyle arabicSmall = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.8,
  );

  static const TextStyle arabicLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 2.0,
  );

  // Clay Typography - Headings (Nunito)
  static const TextStyle heroTitle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Clay Typography - Body (DM Sans)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Clay Typography - Labels (DM Sans)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textTertiary,
    height: 1.0,
    letterSpacing: 0.5,
  );

  // Special Typography (Nunito)
  static const TextStyle countdownTimer = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: AppColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle tasbihCounter = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: AppColors.textOnPrimary,
    height: 1.0,
  );

  // Legacy Aliases (for backward compatibility - will be deprecated)
  @Deprecated('Use heroTitle instead')
  static const TextStyle displayLarge = heroTitle;

  @Deprecated('Use sectionTitle instead')
  static const TextStyle headlineLarge = sectionTitle;

  @Deprecated('Use cardTitle instead')
  static const TextStyle headlineMedium = cardTitle;

  @Deprecated('Use cardTitle instead')
  static const TextStyle headlineSmall = cardTitle;

  @Deprecated('Use bodyLarge instead')
  static const TextStyle bodyLargeLegacy = bodyLarge;

  @Deprecated('Use bodyMedium instead')
  static const TextStyle bodyMediumLegacy = bodyMedium;

  @Deprecated('Use bodySmall instead')
  static const TextStyle bodySmallLegacy = bodySmall;

  @Deprecated('Use labelLarge instead')
  static const TextStyle labelLargeLegacy = labelLarge;

  @Deprecated('Use labelSmall instead')
  static const TextStyle labelMedium = labelSmall;

  @Deprecated('Use cardTitle with primaryAccent color instead')
  static TextStyle get prayerTime => cardTitle.copyWith(
        color: AppColors.primaryAccent,
      );
}
