import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_state.dart';

class RegisterStepTwo extends StatefulWidget {
  final VoidCallback onNext;

  const RegisterStepTwo({super.key, required this.onNext});

  @override
  State<RegisterStepTwo> createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  // Default role ID for users (you can change this if needed)
  final String _roleId = '2'; // Assuming '2' is the role_id for regular users

  @override
  void initState() {
    super.initState();
    // Initialize with any existing form data if needed
    
    // Store the role_id in the form model
    context.read<RegisterBloc>().add(UpdateRegisterFormEvent(
      roleId: _roleId,
    ));
    
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
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.removeListener(() {});
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 30.h),
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
                SizedBox(height: 45.h),

                // Title
                Text(
                  'إثبات ملكية الحساب',
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
                  'سوف تتلقى رمز التحقق الذي سيظهر في صندوق الوارد الخاص ببريدك الإلكتروني أو في قائمة البريد المنهجي',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 40.h),
                // OTP Input Fields - Improved design similar to verify_code_page
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
                                ? const Color(0xFFD63022)
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
                SizedBox(height: 420.h), // Spacer
                // Verify Button
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: 'تأكيد',
                      isLoading: state is CodeVerifying,
                      onPressed: state is CodeVerifying
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final code = _getOtpCode();
                                if (code.length == 6) {
                                  context.read<RegisterBloc>().add(
                                    VerifyCodeEvent(
                                      email:
                                          context
                                              .read<RegisterBloc>()
                                              .formModel
                                              .email,
                                      code: code,
                                    ),
                                  );
                                }
                              }
                            },
                      width: double.infinity,
                      backgroundColor: const Color(0xFFD63022),
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      borderRadius: 16,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
