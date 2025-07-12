import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class AppComponents {
  // Button Themes
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.buttonDisabled;
        }
        return Colors.green; // Changed from AppColors.buttonPrimary to green for testing
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textSecondary;
        }
        return AppColors.textLight;
      }),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      ),
      fixedSize: WidgetStateProperty.all<Size>(
        const Size(327, 48),
      ),
      elevation: WidgetStateProperty.all(0),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'LamaSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textSecondary;
        }
        return AppColors.primary;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: AppColors.buttonDisabled);
        }
        return BorderSide(color: AppColors.primary);
      }),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      ),
      fixedSize: WidgetStateProperty.all<Size>(
        const Size(327, 48),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'LamaSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textSecondary;
        }
        return AppColors.primary;
      }),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'LamaSans',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
  );

  // Input Decoration Theme
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    errorStyle: const TextStyle(color: AppColors.error),
    hintStyle: const TextStyle(color: AppColors.textSecondary),
    constraints: const BoxConstraints(
      maxWidth: 327,
      minHeight: 48,
    ),
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: AppColors.primary, size: 24),
    actionsIconTheme: const IconThemeData(color: AppColors.primary, size: 24),
    titleTextStyle: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontFamily: 'LamaSans',
    ),
    toolbarHeight: 44, // iOS standard height
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      );
}
