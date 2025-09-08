import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/components/custom_buttons.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_bloc.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_event.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_state.dart';
import 'package:wejha/features/auth/google_auth/presentation/pages/complete_profile_page.dart';
import 'package:wejha/core/widgets/loading_indicator.dart';

// Maximum number of retry attempts for Firebase authentication
const int _maxRetryAttempts = 3;

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

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoading = false;
  int _retryCount = 0;
  DateTime? _lastSignInAttempt;
  
  // Configure GoogleSignIn with serverClientId to get ID token
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    // The serverClientId should be the web client ID from your google-services.json
    serverClientId: '1084752019943-i044qrnqf0h0eum4vrb6rb8mnqo0prtm.apps.googleusercontent.com',
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleAuthBloc, GoogleAuthState>(
      listener: (context, state) {
        if (state is GoogleAuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is GoogleAuthCallbackSuccess) {
          setState(() {
            _isLoading = false;
            // Reset retry count on successful authentication
            _retryCount = 0;
          });
          
          final user = state.response.data.user;
          final needsProfileCompletion = state.isNewUser || 
              user.phone.isEmpty || 
              user.gender.isEmpty || 
              user.birthday.isEmpty ||
              user.roleId == '0';
              
          if (needsProfileCompletion) {
            // User needs to complete profile
            debugPrint('User needs to complete profile: isNewUser=${state.isNewUser}, phone=${user.phone}, gender=${user.gender}, birthday=${user.birthday}, roleId=${user.roleId}');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CompleteProfilePage(
                  userId: state.response.data.user.id,
                  existingLastName: state.response.data.user.lname,
                ),
              ),
            );
          } else {
            // Existing user with complete profile, go to home
            debugPrint('User has complete profile, going to home');
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else if (state is GoogleAuthError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
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
                      Container(
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
                          suffixIcon: Image.asset(
                            'assets/icons/google.png',
                            width: 24.w,
                            height: 24.h,
                          ),
                          onPressed: _isLoading ? null : _signInWithGoogle,
                        ),
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
            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: LoadingIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Check if we should allow another sign-in attempt based on rate limiting
  bool _canAttemptSignIn() {
    // If we've exceeded max retries, enforce a cooldown period
    if (_retryCount >= _maxRetryAttempts) {
      final now = DateTime.now();
      // If last attempt was less than 5 minutes ago, don't allow another attempt
      if (_lastSignInAttempt != null && 
          now.difference(_lastSignInAttempt!).inMinutes < 5) {
        return false;
      }
      // Reset retry count after cooldown period
      _retryCount = 0;
    }
    return true;
  }
  
  // Show appropriate error message based on the error
  void _showAuthErrorMessage(dynamic error) {
    String message;
    
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'network-request-failed':
          message = 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
          break;
        case 'too-many-requests':
          message = 'تم تجاوز عدد محاولات تسجيل الدخول. يرجى المحاولة بعد 5 دقائق';
          break;
        case 'user-disabled':
          message = 'تم تعطيل هذا الحساب. يرجى التواصل مع الدعم';
          break;
        case 'operation-not-allowed':
          message = 'تسجيل الدخول بواسطة جوجل غير متاح حالياً';
          break;
        default:
          message = 'فشل تسجيل الدخول: ${error.message}';
      }
    } else {
      message = 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة مرة أخرى';
    }
    
    // Add retry information if we've hit the limit
    if (_retryCount >= _maxRetryAttempts) {
      message += '. يرجى الانتظار 5 دقائق قبل المحاولة مرة أخرى';
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
  
  Future<void> _signInWithGoogle() async {
    // Update last attempt time
    _lastSignInAttempt = DateTime.now();
    
    // Check if we should allow another attempt
    if (!_canAttemptSignIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تجاوز عدد محاولات تسجيل الدخول. يرجى المحاولة بعد 5 دقائق'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }
    
    // Increment retry count
    _retryCount++;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // First sign out from Firebase to ensure a fresh token
      try {
        await FirebaseAuth.instance.signOut();
        debugPrint('Signed out from Firebase');
      } catch (e) {
        debugPrint('Error signing out from Firebase: $e');
      }

      // Sign out from Google and disconnect to force account selection
      try {
        final GoogleSignIn tempGoogleSignIn = GoogleSignIn();
        if (await tempGoogleSignIn.isSignedIn()) {
          await tempGoogleSignIn.disconnect();
          await tempGoogleSignIn.signOut();
        }
        debugPrint('Disconnected from Google');
      } catch (e) {
        debugPrint('Error disconnecting from Google: $e');
      }

      // Begin interactive sign in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
          // Don't count user cancellation as a retry
          _retryCount--;
        });
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      debugPrint('Google Auth obtained - idToken available: ${googleAuth.idToken != null}');
      
      if (googleAuth.idToken == null) {
        debugPrint('Google idToken is null, cannot proceed with Firebase authentication');
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل الحصول على رمز المصادقة'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      try {
        debugPrint('Creating Firebase credential with Google tokens');
        // Create Firebase credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        // Sign in to Firebase with the Google credential
        debugPrint('Signing in to Firebase with credential');
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint('Firebase sign in successful: ${userCredential.user?.uid}');
        
        // Get fresh ID token from Firebase with force refresh
        debugPrint('Requesting Firebase ID token');
        final firebaseIdToken = await userCredential.user?.getIdToken(true);
        
        if (firebaseIdToken != null) {
          debugPrint('Got Firebase ID token: ${firebaseIdToken.substring(0, math.min(20, firebaseIdToken.length))}...');
          
          // Use the Firebase ID token
          context.read<GoogleAuthBloc>().add(
            FirebaseGoogleAuthEvent(idToken: firebaseIdToken)
          );
        } else {
          debugPrint('Failed to get Firebase ID token');
          setState(() {
            _isLoading = false;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('فشل الحصول على رمز المصادقة من Firebase'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('Firebase auth failed: $e');
        setState(() {
          _isLoading = false;
        });
        
        _showAuthErrorMessage(e);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      debugPrint('Error signing in with Google: $e');
      _showAuthErrorMessage(e);
    }
  }
} 