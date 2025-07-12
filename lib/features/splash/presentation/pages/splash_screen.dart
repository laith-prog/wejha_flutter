import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/welcome/presentation/pages/welcome_page.dart';
import 'package:wejha/features/home/presentation/pages/home_page.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_event.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_state.dart';
import 'package:wejha/injection_container.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCheckingAuth = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // Create scale animation from large to normal size
    _scaleAnimation = Tween<double>(
      begin: 4.5,  // Start larger than final size
      end: 1.3,    // End at normal size
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,  // Use a bounce-like curve
    ));
    
    // Start the animation immediately
    _animationController.forward();
    
    // Add a delay before checking auth status for better user experience
    // This allows the animation to complete and gives user time to see the splash screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCheckingAuth = true;
        });
        
        // Add another delay for the auth check
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.read<SplashBloc>().add(CheckAuthStatusEvent());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            // User is authenticated, navigate to home page
            debugPrint('User is authenticated, navigating to home page');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          } else if (state is UnauthenticatedState) {
            // User is not authenticated, navigate to welcome page
            debugPrint('User is not authenticated, navigating to welcome page');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<LoginBloc>(),
                  child: const WelcomePage(),
                ),
              ),
            );
          } else if (state is AuthErrorState) {
            // Error occurred, show error message and navigate to welcome page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<LoginBloc>(),
                  child: const WelcomePage(),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background with waves
            Positioned(
              top: 200.h,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250.h,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
            ),
            // Logo with animation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/Logo_main.png',
                      width: 200.w,
                    ),
                  ),
                  // Show loading indicator when checking auth
                  if (_isCheckingAuth) ...[
                    SizedBox(height: 60.h),
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.w,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'جاري التحقق من تسجيل الدخول...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 