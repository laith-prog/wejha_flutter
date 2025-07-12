import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_state.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from the top left with a smaller height
    path.moveTo(0, size.height * 0.1);

    // Create the wave curve with adjusted control points for a smaller curve
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.05);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.05);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.05);
    var secondEndPoint = Offset(size.width, size.height * 0.1);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Red background
          Container(color: AppColors.primary),
          // Curved white container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.68,
            child: ClipPath(
              clipper: CustomCurveClipper(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                    Text(
                      'اهلا بك في وجهة',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'مرحبا بك في تطبيق وجهة , وجهتك الاولى للتسوق الالكتروني في سوريا',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 100.h),
                    CustomElevatedButton(
                      text: 'تسجيل الدخول',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                    SizedBox(height: 16.h),
                    BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is GoogleAuthSuccess) {
                          // Launch the URL to complete Google authentication
                          _launchURL(state.googleAuthResponse.redirectUrl);
                        } else if (state is GoogleAuthError) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.failure.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is GoogleOAuthCallbackSuccess) {
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم تسجيل الدخول بنجاح'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate to home page
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else if (state is GoogleOAuthCallbackError) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.failure.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomOutlinedButton(
                            text: 'تسجيل عن طريق غوغل',
                            textColor: Colors.black87,
                            borderColor: Colors.transparent,
                            backgroundColor: Color(0xffF5F4FD),
                            fontSize: 12.sp,
                            suffixIcon: state is GoogleAuthLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/icons/google.png',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                            onPressed: state is GoogleAuthLoading
                                ? null
                                : () {
                                    context.read<LoginBloc>().add(const LoginWithGoogleEvent());
                                  },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'او',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomOutlinedButton(
                      text: 'انشاء حساب جديد',
                      textColor: Colors.black87,
                      borderColor: Colors.transparent,
                      backgroundColor: Color(0xffF5F4FD),
                      fontSize: 12.sp,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Logo
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Logo_main.png',
              width: 100.w,
              height: 100.h,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
} 