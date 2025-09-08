import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/network/dio_client.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/core/services/url_launcher_service.dart';

// Register feature imports
import 'package:wejha/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';
import 'package:wejha/features/auth/register/domain/usecases/complete_registration.dart';
import 'package:wejha/features/auth/register/domain/usecases/send_verification_code.dart';
import 'package:wejha/features/auth/register/domain/usecases/verify_code.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';

// Login feature imports
import 'package:wejha/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';
import 'package:wejha/features/auth/login/domain/usecases/login.dart';
import 'package:wejha/features/auth/login/domain/usecases/refresh_token.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';

// Forgot Password feature imports
import 'package:wejha/features/auth/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/forgot_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/reset_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/verify_reset_code.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';

// Splash feature imports

import 'package:wejha/features/splash/presentation/bloc/splash_bloc.dart';

// Profile feature imports
import 'package:wejha/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:wejha/features/profile/domain/repositories/profile_repository.dart';
import 'package:wejha/features/profile/domain/usecases/get_profile.dart';
import 'package:wejha/features/profile/domain/usecases/logout.dart';
import 'package:wejha/features/profile/presentation/bloc/profile_bloc.dart';

// Google Auth feature imports
import 'package:wejha/features/auth/google_auth/data/datasources/google_auth_remote_data_source.dart';
import 'package:wejha/features/auth/google_auth/data/repositories/google_auth_repository_impl.dart';
import 'package:wejha/features/auth/google_auth/domain/repositories/google_auth_repository.dart';
import 'package:wejha/features/auth/google_auth/domain/usecases/complete_profile.dart';
import 'package:wejha/features/auth/google_auth/domain/usecases/firebase_google_auth.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_bloc.dart';
// Home feature imports
import 'package:wejha/features/home/data/datasources/home_remote_data_source.dart';
import 'package:wejha/features/home/data/repositories/home_repository_impl.dart';
import 'package:wejha/features/home/domain/repositories/home_repository.dart';
import 'package:wejha/features/home/domain/usecases/get_home_data.dart';
import 'package:wejha/features/home/presentation/state/home_bloc.dart';

// Search feature imports
import 'package:wejha/features/community/search/data/datasources/search_remote_data_source.dart';
import 'package:wejha/features/community/search/data/repositories/search_repository_impl.dart';
import 'package:wejha/features/community/search/domain/repositories/search_repository.dart';
import 'package:wejha/features/community/search/domain/usecases/search_use_cases.dart'
    as use_cases;
import 'package:wejha/features/community/search/presentation/bloc/search_bloc.dart';

import 'core/network/api_service.dart';
import 'features/auth/forgot_password/data/datasources/forgot_password_remote_datasource.dart';
import 'features/auth/login/data/datasources/login_remote_datasource.dart';
import 'features/auth/register/data/datasources/register_remote_datasource.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => TokenManager(sl()));
  sl.registerLazySingleton(() => UrlLauncherService());

  // Dio client
  sl.registerLazySingleton<Dio>(
    () =>
        DioClient.createDio(baseUrl: ApiConstants.baseUrl, tokenManager: sl()),
  );

  // Features - Register
  // Bloc
  sl.registerFactory(
    () => RegisterBloc(
      sendVerificationCode: sl(),
      verifyCode: sl(),
      completeRegistration: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendVerificationCode(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => CompleteRegistration(sl()));

  // Repository
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Login
  // Bloc
  sl.registerFactory(() => LoginBloc(login: sl(), refreshToken: sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => RefreshToken(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Google Auth
  // Bloc
  sl.registerFactory(
    () => GoogleAuthBloc(completeProfile: sl(), firebaseGoogleAuth: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CompleteProfile(sl()));
  sl.registerLazySingleton(() => FirebaseGoogleAuth(sl()));

  // Repository
  sl.registerLazySingleton<GoogleAuthRepository>(
    () => GoogleAuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GoogleAuthRemoteDataSource>(
    () => GoogleAuthRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc(getHomeData: sl()));
  // Use case
  sl.registerLazySingleton(() => GetHomeData(sl()));
  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // Data source
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl()),
  );

  // Data sources

  // Features - Forgot Password
  // Bloc
  sl.registerFactory(
    () => ForgotPasswordBloc(
      forgotPassword: sl(),
      verifyResetCode: sl(),
      resetPassword: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => VerifyResetCode(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));

  // Repository
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () =>
        ForgotPasswordRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(dio: sl()),
  );

  // Register API Service
  sl.registerLazySingleton(
    () => ApiService(dio: sl(), tokenManager: sl(), loginBloc: sl()),
  );

  // Features - Profile
  // Bloc
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), logout: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      tokenManager: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl(), apiService: sl()),
  );

  // Features - Splash (register after LoginBloc to avoid circular dependency)
  sl.registerFactory(
    () => SplashBloc(tokenManager: sl(), dio: sl(), loginBloc: sl()),
  );

  // Features - Search
  // Bloc
  sl.registerFactory(
    () => SearchBloc(
      generalSearch: sl(),
      searchRealEstateForRent: sl(),
      searchRealEstateForSale: sl(),
      searchRealEstateRooms: sl(),
      searchRealEstateInvestment: sl(),
      searchVehicles: sl(),
      searchServices: sl(),
      searchJobs: sl(),
      getCategories: sl(),
      getSubcategories: sl(),
      getFeaturedListings: sl(),
      getRecentListings: sl(),
      getPopularListings: sl(),
      getNearbyListings: sl(),
      getSimilarListings: sl(),
      getPopularSearches: sl(),
      getRecentSearches: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => use_cases.GeneralSearch(sl()));
  sl.registerLazySingleton(() => use_cases.SearchRealEstateForRent(sl()));
  sl.registerLazySingleton(() => use_cases.SearchRealEstateForSale(sl()));
  sl.registerLazySingleton(() => use_cases.SearchRealEstateRooms(sl()));
  sl.registerLazySingleton(() => use_cases.SearchRealEstateInvestment(sl()));
  sl.registerLazySingleton(() => use_cases.SearchVehicles(sl()));
  sl.registerLazySingleton(() => use_cases.SearchServices(sl()));
  sl.registerLazySingleton(() => use_cases.SearchJobs(sl()));
  sl.registerLazySingleton(() => use_cases.GetCategories(sl()));
  sl.registerLazySingleton(() => use_cases.GetSubcategories(sl()));
  sl.registerLazySingleton(() => use_cases.GetFeaturedListings(sl()));
  sl.registerLazySingleton(() => use_cases.GetRecentListings(sl()));
  sl.registerLazySingleton(() => use_cases.GetPopularListings(sl()));
  sl.registerLazySingleton(() => use_cases.GetNearbyListings(sl()));
  sl.registerLazySingleton(() => use_cases.GetSimilarListings(sl()));
  sl.registerLazySingleton(() => use_cases.GetPopularSearches(sl()));
  sl.registerLazySingleton(() => use_cases.GetRecentSearches(sl()));

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl()),
  );
}
