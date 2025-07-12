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
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {  // Changed from index < 3 to index < 5
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
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
                  'سوف تتلقى رمز التحقق الذي سيطهر في صندوق الوارد الخاص ببريدك الإلكتروني أو في قائمة البريد المنهجي',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 40.h),
                // OTP Input Fields - Simplified version like in the image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Container(
                      height: 57.h,
                      width: 52.w, // Each field is 72 width (72 x 4 = 288)
                      margin: EdgeInsets.only(
                        right: index < 5 ? 3.w : 0,
                      ), // 13 spacing x 3 gaps = 39 → 288 + 39 = 327
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          counterText: '',
                          contentPadding: EdgeInsets.only(bottom: 10),
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
                          if (value == null || value.isEmpty) return '';
                          return null;
                        },
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
