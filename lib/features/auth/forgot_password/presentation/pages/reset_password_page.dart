import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/core/components/success_dialog.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/pages/login_page.dart';
import 'package:wejha/injection_container.dart' as di;

import '../../../../../core/components/custom_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  final TokenManager _tokenManager = di.sl<TokenManager>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1E2C3D)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            _tokenManager.saveTokens(state.response.authToken);
            
            // Show success dialog
            SuccessDialog.show(
              context: context,
              message: 'تم تغيير كلمة المرور بنجاح',
              onClose: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => di.sl<LoginBloc>(),
                      child: const LoginPage(),
                    ),
                  ),
                  (route) => false,
                );
              },
            );
          } else if (state is PasswordResetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 60.h),
                    // Title
                    Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(

                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2C3D),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    // Subtitle
                    Text(
                      'ضع كلمة مرور قوية واحتفظها جيداً.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFFB7B7B7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    // New password
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كلمة المرور الجديدة',
                        style: TextStyle(
                          color: const Color(0xFF1E2C3D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      hintText: 'كلمة المرور',
                      prefixIcon: IconButton(

                        icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 8) {
                          return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Confirm password
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تأكيد كلمة المرور',
                        style: TextStyle(
                          color: const Color(0xFF1E2C3D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'كلمة المرور',

                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 300.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is ResettingPassword
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ForgotPasswordBloc>().add(
                                        ResetPasswordEvent(
                                          email: widget.email,
                                          password: _passwordController.text,
                                          passwordConfirmation: _confirmPasswordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state is ResettingPassword
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('تأكيد'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 