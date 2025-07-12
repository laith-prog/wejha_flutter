import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  static const String fontFamily = 'LamaSans';

  static TextTheme get textTheme => TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}
