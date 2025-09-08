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
  static const String logout = '/api/v1/logout';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String authTest = '/api/v1/auth/test';
  
  // API Endpoints - Forgot Password
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyResetCode = '/api/v1/auth/verify-reset-code';
  static const String resetPassword = '/api/v1/auth/reset-password';
  
  // API Endpoints - Google Auth
  static const String completeProfile = '/api/v1/auth/complete-profile';
  static const String firebaseGoogleAuth = '/api/v1/auth/google/firebase';
  
  // API Endpoints - Profile
  static const String profile = '/api/v1/profile';
  
  // API Endpoints - Community/Home
  static const String communityHome = '/api/community/home';
  
  // API Endpoints - Search
  static const String generalSearch = '/api/search';
  static const String popularSearches = '/api/search/popular';
  static const String recentSearches = '/api/search/recent';
  
  // API Endpoints - Categories
  static const String categories = '/api/listings/categories';
  static const String subcategories = '/api/listings/subcategories';
  
  // API Endpoints - Listings
  static const String featuredListings = '/api/community/featured-listings';
  static const String recentListings = '/api/community/recent-listings';
  static const String popularListings = '/api/community/popular-listings';
  static const String nearbyListings = '/api/community/nearby-listings';
  static const String similarListings = '/api/listings/{id}/similar';
  
  // API Endpoints - Real Estate Search
  static const String realEstateRentalsSearch = '/api/real-estate/rentals/search';
  static const String realEstateSalesSearch = '/api/real-estate/sales/search';
  static const String realEstateRoomsSearch = '/api/real-estate/rooms/search';
  static const String realEstateInvestmentSearch = '/api/real-estate/investment/search';
  
  // API Endpoints - Vehicles Search
  static const String vehiclesSearch = '/api/vehicles/search';
  
  // API Endpoints - Services Search
  static const String servicesSearch = '/api/services/search';
  
  // API Endpoints - Jobs Search
  static const String jobsSearch = '/api/jobs/search';
  
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