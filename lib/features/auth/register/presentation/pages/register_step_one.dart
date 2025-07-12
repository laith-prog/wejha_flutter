import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_state.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/core/components/custom_text_field.dart';

class RegisterStepOne extends StatefulWidget {
  final VoidCallback onNext;

  const RegisterStepOne({super.key, required this.onNext});

  @override
  State<RegisterStepOne> createState() => _RegisterStepOneState();
}

class _RegisterStepOneState extends State<RegisterStepOne> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with any existing form data
    final formModel = context.read<RegisterBloc>().formModel;
    _fnameController.text = formModel.fname ?? '';
    _lnameController.text = formModel.lname ?? '';
    _emailController.text = formModel.email;
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button Row
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                // App Logo
                Container(
                  width: 114.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 2.w,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/Mask_group.png',
                      width: 142.w,
                      height: 200.h,
                    ),
                  ),
                ),
                // Arabic Title
                Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8.h),
                // Welcome Text
                Text(
                  'مرحبا بك في تطبيق وجهة، وجهتك الأولى للتسوق الإلكتروني في سوريا',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 32.h),
                // First Name and Last Name fields in a row
                Row(
                  children: [
                    // Last Name (on the right in RTL)
                    Expanded(
                      child: CustomTextField(
                        width: 157.w,
                        controller: _lnameController,
                        hintText: 'النسبة',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال النسبة';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            UpdateRegisterFormEvent(lname: value),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // First Name (on the left in RTL)
                    Expanded(
                      child: CustomTextField(
                        width: 157.w,
                        controller: _fnameController,
                        hintText: 'الاسم الأول',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم الأول';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            UpdateRegisterFormEvent(fname: value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Email field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'الرجاء إدخال بريد إلكتروني صالح';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    context.read<RegisterBloc>().add(
                      UpdateRegisterFormEvent(email: value),
                    );
                  },
                ),
                SizedBox(height: 32.h),
                // Register Button
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: 'إنشاء الحساب',
                      isLoading: state is VerificationCodeSending,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterBloc>().add(
                            SendVerificationCodeEvent(
                              fname: _fnameController.text,
                              lname: _lnameController.text,
                              email: _emailController.text,
                            ),
                          );
                        }
                      },
                      width: 327.w,
                      height: 48.h,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      borderRadius: 16,
                    );
                  },
                ),
                SizedBox(height: 190.h),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextButton(
                      text: 'تسجيل الدخول',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      textColor: AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      borderRadius: 16,
                    ),
                    Text(
                      'لديك حساب سابق؟',
                      style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
