import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wejha/core/config/environment.dart';
import 'package:wejha/core/utils/environment_checker.dart';
import 'package:wejha/core/services/deep_link_service.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_page.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/pages/login_page.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:wejha/features/auth/forgot_password/presentation/pages/verify_code_page.dart';
import 'package:wejha/features/auth/welcome/presentation/pages/welcome_page.dart';
import 'package:wejha/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wejha/features/profile/presentation/pages/profile_page.dart';
import 'package:wejha/features/home/presentation/pages/home_page.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wejha/features/splash/presentation/pages/splash_screen.dart';
import 'package:wejha/core/theme/app_theme.dart';
import 'injection_container.dart' as di;

// Set this to change environment
const Environment currentEnvironment = Environment.production;
// For production use: Environment.production

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment before initializing dependencies
  EnvironmentConfig.setEnvironment(currentEnvironment);
  EnvironmentChecker.printEnvironmentInfo();
  
  await di.init();
  
  // Initialize app without requiring deep link service to work
  runApp(const MyApp());
  
  // Initialize deep link service after app has started
  // This way, if it fails, the app is already running
  _initializeDeepLinkService();
}

// Initialize deep link service separately to avoid blocking app startup
Future<void> _initializeDeepLinkService() async {
  try {
    await di.sl<DeepLinkService>().init();
    debugPrint('Deep link service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing DeepLinkService: $e');
    // App continues running even if deep link service fails
  }
}

// Initialize the blocs only when the screen needs it
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _deepLinkSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    // Listen for deep links with error handling
    _setupDeepLinkListener();
  }
  
  void _setupDeepLinkListener() {
    try {
      _deepLinkSubscription = di.sl<DeepLinkService>().deepLinkStream.listen((uri) {
        debugPrint('Received deep link in main.dart: $uri');
        _handleDeepLink(uri);
      }, onError: (error) {
        debugPrint('Error in deep link stream: $error');
      });
    } catch (e) {
      debugPrint('Could not subscribe to deep links: $e');
    }
  }
  
  void _handleDeepLink(Uri uri) {
    debugPrint('Handling deep link: $uri');
    
    // Check for Google OAuth URL patterns
    if (uri.path.contains('google/callback') || 
        uri.path.contains('/api/v1/auth/google')) {
      debugPrint('Detected Google OAuth callback');
      
      // Get the login bloc and dispatch the event
      final loginBloc = di.sl<LoginBloc>();
      loginBloc.add(HandleGoogleOAuthCallbackEvent(uri: uri));
      
      // Navigate to the appropriate screen after successful OAuth
      // This depends on your app's flow - adjust as needed
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      });
    }
  }
  
  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
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
          builder: (_) => BlocProvider(
            create: (_) => di.sl<LoginBloc>(),
            child: const WelcomePage(),
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
