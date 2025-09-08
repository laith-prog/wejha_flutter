import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/reset_password_page.dart';
import 'package:wejha/injection_container.dart' as di;

class VerifyCodePage extends StatefulWidget {
  final String email;
  
  const VerifyCodePage({super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  // Timer for resend code functionality
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResendCode = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to focus nodes to rebuild when focus changes
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    
    // Set focus to first field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
    
    // Start countdown timer
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.removeListener(() {});
      node.dispose();
    }
    super.dispose();
  }
  
  void _startCountdownTimer() {
    setState(() {
      _remainingSeconds = 60;
      _canResendCode = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResendCode = true;
          timer.cancel();
        }
      });
    });
  }
  
  void _resendCode() {
    if (_canResendCode) {
      // Dispatch forgot password event again to resend code
      context.read<ForgotPasswordBloc>().add(
        SendForgotPasswordEmailEvent(email: widget.email),
      );
      
      // Reset the timer
      _startCountdownTimer();
      
      // Show message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رمز جديد إلى بريدك الإلكتروني'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      // Move to next field
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.length > 1) {
      // Handle pasting a full code
      final fullCode = value;
      if (fullCode.length <= 6) {
        for (int i = 0; i < fullCode.length; i++) {
          if (i < 6) {
            _otpControllers[i].text = fullCode[i];
          }
        }
        // Focus on the next empty field or the last field
        int nextIndex = fullCode.length < 6 ? fullCode.length : 5;
        _focusNodes[index].unfocus();
        if (nextIndex < 6) {
          FocusScope.of(context).requestFocus(_focusNodes[nextIndex]);
        }
      }
    }
  }

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_otpControllers[index].text.isEmpty && index > 0) {
          // Move to previous field on backspace if current field is empty
          _focusNodes[index].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          // Clear the previous field
          _otpControllers[index - 1].clear();
        } else if (_otpControllers[index].text.isNotEmpty) {
          // Clear current field
          _otpControllers[index].clear();
        }
      }
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
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
          if (state is ResetCodeVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to reset password page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<ForgotPasswordBloc>(),
                  child: ResetPasswordPage(email: state.response.email),
                ),
              ),
            );
          } else if (state is ResetCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 50.h),
                    // Title
                    Text(
                      'إثبات ملكية الحساب',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2C3D),
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    // Description
                    Text(
                      'سوف تتلقى رمز التحقق الذي سيظهر في صندوق الوارد الخاص ببريدك الإلكتروني أو في قائمة البريد المهملات',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 40.h),
                    // OTP Input Fields
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: 45.w,
                            height: 50.h,
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _focusNodes[index].hasFocus 
                                    ? Theme.of(context).primaryColor 
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: RawKeyboardListener(
                                focusNode: FocusNode(),
                                onKey: (event) => _handleKeyEvent(event, index),
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                    contentPadding: EdgeInsets.zero,
                                    errorStyle: const TextStyle(
                                      height: 0,
                                      fontSize: 0,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => _onOtpChanged(value, index),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Resend code section
                    Center(
                      child: TextButton(
                        onPressed: _canResendCode ? _resendCode : null,
                        child: Text(
                          _canResendCode 
                              ? 'إعادة إرسال الرمز' 
                              : 'إعادة إرسال الرمز بعد $_remainingSeconds ثانية',
                          style: TextStyle(
                            color: _canResendCode 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 320.h), // Spacer
                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: state is VerifyingResetCode
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final code = _getOtpCode();
                                  if (code.length == 6) {
                                    context.read<ForgotPasswordBloc>().add(
                                          VerifyResetCodeEvent(
                                            email: widget.email,
                                            code: code,
                                          ),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('الرجاء إدخال رمز التحقق كاملاً'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: state is VerifyingResetCode
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