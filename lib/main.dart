import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'package:wejha/core/config/environment.dart';
import 'package:wejha/core/utils/environment_checker.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_page.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/pages/login_page.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/verify_code_page.dart';
import 'package:wejha/features/auth/welcome/presentation/pages/welcome_page.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_bloc.dart';
import 'package:wejha/features/auth/google_auth/presentation/pages/complete_profile_page.dart';

import 'package:wejha/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wejha/features/profile/presentation/pages/profile_page.dart';
import 'package:wejha/features/home/presentation/pages/home_page.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wejha/features/splash/presentation/pages/splash_screen.dart';
import 'package:wejha/features/community/search/presentation/bloc/search_bloc.dart';
import 'package:wejha/features/community/search/presentation/pages/search_page.dart';
import 'package:wejha/core/theme/app_theme.dart';
import 'injection_container.dart' as di;

// Set this to change environment
const Environment currentEnvironment = Environment.production;
// For production use: Environment.production

// Global variable to track if Firebase is initialized
bool isFirebaseInitialized = false;

Future<void> initializeFirebase() async {
  if (isFirebaseInitialized) return;
  
  try {
    debugPrint('Attempting to initialize Firebase with options: ${DefaultFirebaseOptions.currentPlatform}');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
    debugPrint('Firebase initialized successfully');
    
    // Verify Firebase Auth is working
    try {
      final auth = FirebaseAuth.instance;
      debugPrint('Firebase Auth instance created: ${auth.hashCode}');
    } catch (e) {
      debugPrint('Error accessing Firebase Auth: $e');
    }
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment before initializing dependencies
  EnvironmentConfig.setEnvironment(currentEnvironment);
  EnvironmentChecker.printEnvironmentInfo();
  
  // Try to initialize Firebase, but continue even if it fails
  await initializeFirebase();
  
  await di.init();
  
  // Initialize app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          title: 'Wejha App',
          theme: AppTheme.lightTheme,
          navigatorKey: _navigatorKey,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: BlocProvider(
            create: (context) => di.sl<SplashBloc>(),
            child: const SplashScreen(),
          ),
        );
      }
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('Navigating to: ${settings.name}');
    
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<SplashBloc>(),
            child: const SplashScreen(),
          ),
        );
        
      case 'sign-in-view':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<LoginBloc>(),
            child: const LoginPage(),
          ),
        );
        
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<LoginBloc>(),
            child: const LoginPage(),
          ),
        );
        
      case '/register':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<RegisterBloc>(),
            child: const RegisterPage(),
          ),
        );
        
      case '/complete-profile':
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final String userId = args['userId'];
        final String existingLastName = args['existingLastName'] ?? '';
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<GoogleAuthBloc>(),
            child: CompleteProfilePage(
              userId: userId,
              existingLastName: existingLastName,
            ),
          ),
        );

      case '/forgot-password':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<ForgotPasswordBloc>(),
            child: const ForgotPasswordPage(),
          ),
        );
        
      case '/verify-code':
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<ForgotPasswordBloc>(),
            child: VerifyCodePage(email: email),
          ),
        );
        
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<ProfileBloc>(),
            child: const ProfilePage(),
          ),
        );
        
      case '/home':
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
        
      case '/welcome':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<LoginBloc>()),
              BlocProvider(create: (_) => di.sl<GoogleAuthBloc>()),
            ],
            child: const WelcomePage(),
          ),
        );

      case '/search':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => di.sl<SearchBloc>(),
            child: const SearchPage(),
          ),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<SplashBloc>(),
            child: const SplashScreen(),
          ),
        );
    }
  }
}
