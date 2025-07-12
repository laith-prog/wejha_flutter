import '../config/environment.dart';

class ApiConstants {
  // Base URL
  static String get baseUrl => EnvironmentConfig.baseUrl;
  
  // API Endpoints - Register
  static const String sendVerificationCode = '/api/v1/verification/send';
  static const String verifyCode = '/api/v1/verification/verify';
  static const String completeRegistration = '/api/v1/register/complete';
  
  // API Endpoints - Login
  static const String login = '/api/v1/login';
  static const String googleAuth = '/api/v1/auth/google';
  static const String googleAuthCallback = '/api/v1/auth/google/callback';
  static const String logout = '/api/v1/logout';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String authTest = '/api/v1/auth/test';
  
  // API Endpoints - Forgot Password
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyResetCode = '/api/v1/auth/verify-reset-code';
  static const String resetPassword = '/api/v1/auth/reset-password';
  
  // API Endpoints - Profile
  static const String profile = '/api/v1/profile';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
} 