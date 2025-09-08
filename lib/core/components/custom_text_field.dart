import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRTL;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.width,
    this.height,
    this.contentPadding,
    this.isRTL = true, // Default to RTL for Arabic
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??327.w,
      // Use constraints to maintain minimum height even with error text
      constraints: BoxConstraints(
        minHeight: height??48.h,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 10.sp,
          fontFamily: 'LamaSans',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
            fontFamily: 'LamaSans',
          ),
          hintTextDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding:
          contentPadding ??
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          filled: true,
          fillColor: AppColors.surface,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          // Make error text appear outside the field to maintain field height
          errorStyle: TextStyle(
            color: AppColors.error,
            fontSize: 10.sp,
          ),
          // Ensure the field doesn't resize when error appears
          isDense: true,
        ),
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}