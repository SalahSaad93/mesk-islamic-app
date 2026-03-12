import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/clay_radii.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryAccent,
      primary: AppColors.primaryAccent,
      secondary: AppColors.secondaryAccent,
      surface: AppColors.surface,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.canvas,
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: ClayRadii.cardRadius,
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.sectionTitle,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryAccent,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: AppTextStyles.labelLarge,
      unselectedLabelStyle: AppTextStyles.labelSmall,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heroTitle,
      headlineLarge: AppTextStyles.sectionTitle,
      headlineMedium: AppTextStyles.cardTitle,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTextStyles.bodySmall,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryAccent,
      labelStyle: AppTextStyles.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: ClayRadii.buttonRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.surface;
        }
        return AppColors.textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent;
        }
        return AppColors.border;
      }),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryAccent,
      brightness: Brightness.dark,
      primary: AppColors.primaryAccent,
      secondary: AppColors.secondaryAccent,
      surface: const Color(0xFF1E1E1E),
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textOnPrimary,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: ClayRadii.cardRadius,
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.textOnPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: AppColors.primaryAccent,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: AppTextStyles.labelLarge.copyWith(
        color: AppColors.textOnPrimary,
      ),
      unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textOnPrimary,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heroTitle,
      headlineLarge: AppTextStyles.sectionTitle,
      headlineMedium: AppTextStyles.cardTitle,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ClayRadii.buttonRadius,
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textTertiary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedColor: AppColors.primaryAccent,
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textOnPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: ClayRadii.buttonRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2C2C2C),
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF1E1E1E);
        }
        return AppColors.textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent;
        }
        return const Color(0xFF2C2C2C);
      }),
    ),
  );
}
