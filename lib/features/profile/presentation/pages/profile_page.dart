import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/welcome/presentation/pages/welcome_page.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_info_item.dart';
import 'package:wejha/injection_container.dart' as di;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            // Navigate to welcome page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<LoginBloc>(),
                  child: const WelcomePage(),
                ),
              ),
              (route) => false,
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LogoutLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري تسجيل الخروج...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            final user = state.profileResponse.user;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  // Profile Image
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: user.photo != null && user.photo!.isNotEmpty
                        ? NetworkImage(user.photo!)
                        : null,
                    child: user.photo == null || user.photo!.isEmpty
                        ? Text(
                            '${user.fname[0]}${user.lname[0]}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  // Full Name
                  Text(
                    '${user.fname} ${user.lname}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Profile Info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معلومات الحساب',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Divider(height: 24.h),
                        ProfileInfoItem(
                          icon: Icons.phone,
                          title: 'رقم الهاتف',
                          value: user.phone ?? 'غير محدد',
                        ),
                        SizedBox(height: 16.h),
                        ProfileInfoItem(
                          icon: Icons.person,
                          title: 'الجنس',
                          value: user.gender == 'male' ? 'ذكر' : (user.gender == 'female' ? 'أنثى' : 'غير محدد'),
                        ),
                        SizedBox(height: 16.h),
                        ProfileInfoItem(
                          icon: Icons.calendar_today,
                          title: 'تاريخ الميلاد',
                          value: user.birthday != null
                              ? '${user.birthday!.day}/${user.birthday!.month}/${user.birthday!.year}'
                              : 'غير محدد',
                        ),
                        SizedBox(height: 16.h),
                        ProfileInfoItem(
                          icon: Icons.verified_user,
                          title: 'نوع الحساب',
                          value: user.type == 'user' ? 'مستخدم' : user.type,
                        ),
                        SizedBox(height: 16.h),
                        ProfileInfoItem(
                          icon: Icons.login,
                          title: 'طريقة التسجيل',
                          value: user.authProvider == 'email' ? 'البريد الإلكتروني' : user.authProvider,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Logout Button
                  CustomElevatedButton(
                    text: 'تسجيل الخروج',
                    backgroundColor: Colors.red,
                    isLoading: state is LogoutLoading,
                    onPressed: () {
                      context.read<ProfileBloc>().add(const LogoutEvent());
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('حدث خطأ ما، يرجى المحاولة مرة أخرى'),
          );
        },
      ),
    );
  }
} 