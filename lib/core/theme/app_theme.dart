import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_components.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'LamaSans',
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
   
      error: AppColors.error,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textPrimary,

      onError: AppColors.textLight,
      outline: AppColors.border,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTypography.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    primaryTextTheme: AppTypography.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    elevatedButtonTheme: AppComponents.elevatedButtonTheme,
    outlinedButtonTheme: AppComponents.outlinedButtonTheme,
    textButtonTheme: AppComponents.textButtonTheme,
    inputDecorationTheme: AppComponents.inputDecorationTheme,
    appBarTheme: AppComponents.appBarTheme,
    bottomNavigationBarTheme: AppComponents.bottomNavigationBarTheme,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      space: 1,
      thickness: 1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'LamaSans',

    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: const Color(0xFF1E1E1E), // Dark surface

      error: AppColors.error,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,

      onError: AppColors.textLight,
      outline: AppColors.border,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    primaryTextTheme: AppTypography.textTheme.apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    elevatedButtonTheme: AppComponents.elevatedButtonTheme,
    outlinedButtonTheme: AppComponents.outlinedButtonTheme,
    textButtonTheme: AppComponents.textButtonTheme,
    inputDecorationTheme: AppComponents.inputDecorationTheme,
    appBarTheme: AppComponents.appBarTheme,
    bottomNavigationBarTheme: AppComponents.bottomNavigationBarTheme,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      space: 1,
      thickness: 1,
    ),
  );
}
