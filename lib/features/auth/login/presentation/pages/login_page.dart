import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_state.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_page.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/injection_container.dart' as di;

import '../../../../../core/components/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final TokenManager _tokenManager = di.sl<TokenManager>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with any existing form data
    final formModel = context.read<LoginBloc>().formModel;
    _emailController.text = formModel.email;
    _passwordController.text = formModel.password;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E2C3D)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Save tokens to SharedPreferences
            _tokenManager.saveTokens(state.loginResponse.authToken).then((_) {
              debugPrint('Tokens saved successfully after login');
              // Navigate to home page after successful login
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            });
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is GoogleOAuthCallbackSuccess) {
            // Save tokens for Google OAuth login as well
            _tokenManager.saveTokens(state.loginResponse.authToken).then((_) {
              debugPrint('Tokens saved successfully after Google OAuth');
              // Navigate to home page after successful login
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App Logo
                    Image.asset(
                      'assets/images/Mask_group.png',
                      width: 114.w,
                      height: 172.h,

                    ),
                    // Arabic Title
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2C3D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    // Welcome Text
                    Text(
                      'مرحبا بك في تطبيق وجهة، وجهتك الأولى للتسوق الإلكتروني في سوريا',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 50.h),
                    // Email field
                    CustomTextField(

                      controller: _emailController,
                      hintText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,

                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'الرجاء إدخال بريد إلكتروني صالح';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Update form model when email changes
                        context.read<LoginBloc>().add(
                              UpdateLoginFormEvent(email: value),
                            );
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Password field
                    CustomTextField(
                      hintText: 'كلمة المرور',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      controller: _passwordController,

                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Update form model when password changes
                        context.read<LoginBloc>().add(
                              UpdateLoginFormEvent(password: value),
                            );
                      },
                    ),
                    SizedBox(height: 10.h),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => di.sl<ForgotPasswordBloc>(),
                                child: const ForgotPasswordPage(),
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Center(
                          child: Text(

                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(

                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                        LoginWithEmailPasswordEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state is LoginLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('تسجيل الدخول'),
                      ),
                    ),
                    SizedBox(height: 170.h),
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => di.sl<RegisterBloc>(),
                                  child: const RegisterPage(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
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