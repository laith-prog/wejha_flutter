import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'dart:io';
import 'dart:convert';

import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_state.dart';
import 'package:wejha/core/components/custom_text_field.dart';
import 'package:wejha/core/components/custom_buttons.dart';

class RegisterStepThree extends StatefulWidget {
  const RegisterStepThree({super.key});

  @override
  State<RegisterStepThree> createState() => _RegisterStepThreeState();
}

class _RegisterStepThreeState extends State<RegisterStepThree> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _selectedGender = '';
  String _selectedCountryCode = '+963';
  XFile? _profileImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final formModel = context.read<RegisterBloc>().formModel;
    _phoneController.text = formModel.phone;
    _birthdayController.text = formModel.birthday;
    _selectedGender = formModel.gender;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _birthdayController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(_birthdayController.text)
              : DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
              ),
              bodyMedium: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format for display
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      // Add to bloc with API format
      // ignore: use_build_context_synchronously
      context.read<RegisterBloc>().add(
        UpdateRegisterFormEvent(
          birthday: DateFormat('yyyy-MM-dd').format(picked),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        requestFullMetadata: true, // Enable full metadata to validate image type
      );
      
      if (image != null) {
        // Validate file extension
        final String extension = image.path.split('.').last.toLowerCase();
        if (!['jpeg', 'jpg', 'png', 'gif'].contains(extension)) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يجب أن تكون الصورة من نوع: jpeg, png, jpg, gif'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Validate file is an actual image and get binary data
        try {
          final bytes = await image.readAsBytes();
          
          // Check if the file starts with image signatures
          if (!_isValidImageFile(bytes)) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('الملف المحدد ليس صورة صالحة'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          
          setState(() {
            _profileImage = image;
          });
          
          // Store the image path in the form model
          context.read<RegisterBloc>().add(
            UpdateRegisterFormEvent(
              photo: image.path, // Store the file path instead of base64
            ),
          );
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الملف المحدد ليس صورة صالحة'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تحميل الصورة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper function to validate image file by checking file signatures
  bool _isValidImageFile(List<int> bytes) {
    if (bytes.length < 4) return false;

    // Check for JPEG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }
    
    // Check for PNG
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return true;
    }
    
    // Check for GIF
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Progress bar
                  SizedBox(height: 17.h),
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
                              widthFactor: 0.85,
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
                  SizedBox(height: 40.h),
                  Text(
                    'معلوماتك الشخصية',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'ادخل معلوماتك الشخصية التي تهمنا',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Profile image upload
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child:
                          _profileImage == null
                              ? DottedBorder(
                                color: AppColors.textSecondary,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(16.r),
                                dashPattern: const [6, 3],
                                strokeWidth: 1.5,
                                child: Container(
                                  width: 87.w,
                                  height: 87.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        color: AppColors.primary,
                                        size: 32.sp,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'انقر هنا لتحميل صورة حسابك',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 7.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  File(_profileImage!.path),
                                  width: 110.w,
                                  height: 110.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Gender selection
                  Text(
                    'الجنس',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,

                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: DropdownButton<String>(
                          value:
                              _selectedGender.isEmpty ? null : _selectedGender,
                          hint: Text(
                            'اختر الجنس',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12.sp,
                            fontFamily: 'LamaSans',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('ذكر')),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('أنثى'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                            context.read<RegisterBloc>().add(
                              UpdateRegisterFormEvent(gender: value!),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Birthday field
                  Text(
                    'تاريخ الميلاد',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _birthdayController,
                        hintText: 'اختر تاريخ ميلادك',
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                          size: 20.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء اختيار تاريخ الميلاد';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Phone number field
                  Text(
                    'رقم الهاتف',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: 'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.border, width: 1),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      constraints: BoxConstraints(minWidth: 100.w),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: 20.sp,
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: '+962',
                              child: Text('🇯🇴 +962'),
                            ),
                            DropdownMenuItem(
                              value: '+20',
                              child: Text('🇪🇬 +20'),
                            ),
                            DropdownMenuItem(
                              value: '+966',
                              child: Text('🇸🇦 +966'),
                            ),
                            DropdownMenuItem(
                              value: '+963',
                              child: Text('🇸🇾 +963'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryCode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      // Add phone number format validation
                      if (!RegExp(r'^[0-9]{9,10}$').hasMatch(value)) {
                        return 'الرجاء إدخال رقم هاتف صحيح';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(
                        UpdateRegisterFormEvent(phone: value),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Password field
                  Text(
                    'كلمة المرور',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'كلمة المرور',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
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
                      // Check for uppercase, lowercase, number and symbol
                      if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>])',
                      ).hasMatch(value)) {
                        return 'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة وأرقام ورموز';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(
                        UpdateRegisterFormEvent(password: value),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Confirm Password field
                  Text(
                    'تأكيد كلمة المرور',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'تأكيد كلمة المرور',
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(
                        UpdateRegisterFormEvent(passwordConfirmation: value),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  // Submit Button
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return CustomElevatedButton(
                        text: 'التالي',

                        isLoading: state is RegistrationCompleting,
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _birthdayController.text.isNotEmpty) {
                            context.read<RegisterBloc>().add(
                              CompleteRegistrationEvent(
                                email:
                                    context
                                        .read<RegisterBloc>()
                                        .formModel
                                        .email,
                                password: _passwordController.text,
                                passwordConfirmation:
                                    _confirmPasswordController.text,
                                phone: _phoneController.text,
                                gender: _selectedGender,
                                birthday: DateFormat('yyyy-MM-dd').format(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).parse(_birthdayController.text),
                                ),
                                // The role_id and photo are already in the form model
                                // We don't need to pass them again as they were added earlier
                              ),
                            );
                          } else if (_birthdayController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('الرجاء اختيار تاريخ الميلاد'),
                              ),
                            );
                          }
                        },
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
