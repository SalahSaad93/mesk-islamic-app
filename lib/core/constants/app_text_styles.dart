import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Arabic text styles
  static TextStyle get arabicHeading => GoogleFonts.amiri(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        height: 1.8,
      );

  static TextStyle get arabicBody => GoogleFonts.amiri(
        fontSize: 22,
        fontWeight: FontWeight.normal,
        color: AppColors.textDark,
        height: 2.0,
      );

  static TextStyle get arabicSmall => GoogleFonts.amiri(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppColors.textMedium,
        height: 1.8,
      );

  static TextStyle get arabicLarge => GoogleFonts.amiri(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        height: 2.0,
      );

  // English text styles
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textMedium,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textMedium,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textLight,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMedium,
      );

  static TextStyle get prayerTime => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryGreen,
      );

  static TextStyle get countdownTimer => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      );

  static TextStyle get tasbihCounter => GoogleFonts.inter(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      );
}
