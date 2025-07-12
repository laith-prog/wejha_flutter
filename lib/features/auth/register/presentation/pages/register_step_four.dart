import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';

class RegisterStepFour extends StatefulWidget {
  final VoidCallback onNext;

  const RegisterStepFour({super.key, required this.onNext});

  @override
  State<RegisterStepFour> createState() => _RegisterStepFourState();
}

class _RegisterStepFourState extends State<RegisterStepFour> {
  String? _selectedRoleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 30.h),
            // Progress bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90.w,
                  child: Stack(
                    children: [
                      Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F0F5),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.75, // 3/4 steps completed
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Back button
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 45.h),
            // Title
            Text(
              'اختر نوع الحساب',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2C3D),
              ),
              textAlign: TextAlign.end,
            ),
            SizedBox(height: 16.h),
            // Description
            Text(
              'الرجاء اختيار نوع الحساب المناسب عند عملية إنشاء الحساب',
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              textAlign: TextAlign.end,
            ),
            SizedBox(height: 40.h),
            // Role selection cards
            Row(
              children: [
                // Seller/Merchant Card
                Expanded(
                  child: _buildRoleCard(
                    title: 'بائع-تاجر',
                    image: 'assets/icons/Group.png',
                    roleId: '2',
                  ),
                ),
                SizedBox(width: 16.w),
                // Regular User Card
                Expanded(
                  child: _buildRoleCard(
                    title: 'مستخدم عادي',
                    image: 'assets/icons/Product_review_5_.png',
                    roleId: '3',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String image,
    required String roleId,
  }) {
    final isSelected = _selectedRoleId == roleId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoleId = roleId;
        });
        // Update the form model with the selected role
        context.read<RegisterBloc>().add(
          UpdateRegisterFormEvent(roleId: roleId),
        );
        // Move to next step
        widget.onNext();
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: 60.w,
              height: 60.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 