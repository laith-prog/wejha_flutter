import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/core/components/custom_text_field.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/widgets/loading_indicator.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_bloc.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_event.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_state.dart';
import 'package:wejha/injection_container.dart' as sl;

class CompleteProfilePage extends StatefulWidget {
  final String userId;
  final String? existingLastName;
  
  const CompleteProfilePage({
    super.key,
    required this.userId,
    this.existingLastName,
  });

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  
  String _selectedGender = 'male';
  int _selectedRole = 2; // Default to regular user (customer)
  DateTime? _selectedDate;
  String _selectedCountryCode = '+963';
  XFile? _profileImage;
  bool _showLastNameField = true;
  
  @override
  void initState() {
    super.initState();
    // If we already have a last name, pre-fill it and hide the field
    if (widget.existingLastName != null && widget.existingLastName!.isNotEmpty) {
      _lastNameController.text = widget.existingLastName!;
      _showLastNameField = false;
    }
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _birthdayController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
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
        _selectedDate = picked;
        // Format for display
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        requestFullMetadata: true,
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

        setState(() {
          _profileImage = image;
        });
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.sl<GoogleAuthBloc>(),
      child: BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
        listener: (context, state) {
          if (state is ProfileCompleted) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is GoogleAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: state is GoogleAuthLoading
                ? const Center(child: LoadingIndicator())
                : Padding(
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
                            // Last Name field - only show if we don't have one already
                            if (_showLastNameField) ...[
                              Text(
                                'اسم العائلة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                controller: _lastNameController,
                                hintText: 'ادخل اسم العائلة',
                                isRTL: true,
                                validator: (value) {
                                  // Last name is optional
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                            ],
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
                                    value: _selectedGender,
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
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.only(left: 8.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: AppColors.border, width: 1),
                                  ),
                                ),
                                child: CountryCodePicker(
                                  onChanged: (CountryCode countryCode) {
                                    setState(() {
                                      _selectedCountryCode = countryCode.dialCode!;
                                    });
                                  },
                                  initialSelection: 'SY',
                                  favorite: const ['SY', 'SA', 'EG', 'JO'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  padding: EdgeInsets.zero,
                                  textStyle: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
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
                            ),
                            SizedBox(height: 16.h),
                            // Account type selection
                            Text(
                              'نوع الحساب',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                // Seller Card
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = 3;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: _selectedRole == 3 ? AppColors.primary : Colors.grey.shade300,
                                          width: _selectedRole == 3 ? 2 : 1,
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
                                            'assets/icons/Group.png',
                                            width: 60.w,
                                            height: 60.h,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'بائع-تاجر',
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
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Customer Card
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = 2;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: _selectedRole == 2 ? AppColors.primary : Colors.grey.shade300,
                                          width: _selectedRole == 2 ? 2 : 1,
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
                                            'assets/icons/Product_review_5_.png',
                                            width: 60.w,
                                            height: 60.h,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'مستخدم عادي',
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
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            // Submit Button
                            CustomElevatedButton(
                              text: 'إكمال الملف الشخصي',
                              isLoading: state is GoogleAuthLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Format birthday for API
                                  String formattedBirthday = '';
                                  if (_birthdayController.text.isNotEmpty) {
                                    formattedBirthday = DateFormat('yyyy-MM-dd').format(
                                      DateFormat('dd/MM/yyyy').parse(_birthdayController.text)
                                    );
                                  }
                                  
                                  context.read<GoogleAuthBloc>().add(
                                    CompleteProfileEvent(
                                      userId: widget.userId,
                                      roleId: _selectedRole,
                                      phone: _selectedCountryCode + _phoneController.text,
                                      gender: _selectedGender,
                                      birthday: formattedBirthday,
                                      lname: _lastNameController.text,
                                      photo: _profileImage?.path,
                                    ),
                                  );
                                }
                              },
                              backgroundColor: AppColors.primary,
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
} 