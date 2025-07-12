import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const SuccessDialog({
    super.key,
    required this.message,
    this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required String message,
    VoidCallback? onClose,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SuccessDialog(
          message: message,
          onClose: onClose ?? () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onClose ?? () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: Color(0xFF4CD964),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 32.w,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
} 