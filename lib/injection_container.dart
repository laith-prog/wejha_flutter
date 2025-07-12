import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/network/api_service.dart';
import 'package:wejha/core/network/dio_client.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/core/services/deep_link_service.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/core/services/url_launcher_service.dart';
import 'package:wejha/features/auth/forgot_password/data/datasources/forgot_password_remote_datasource.dart';
import 'package:wejha/features/auth/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/forgot_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/reset_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/verify_reset_code.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:wejha/features/auth/login/data/datasources/login_remote_datasource.dart';
import 'package:wejha/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';
import 'package:wejha/features/auth/login/domain/usecases/get_google_auth_url.dart';
import 'package:wejha/features/auth/login/domain/usecases/handle_google_oauth_callback.dart';
import 'package:wejha/features/auth/login/domain/usecases/login.dart';
import 'package:wejha/features/auth/login/domain/usecases/refresh_token.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/register/data/datasources/register_remote_datasource.dart';
import 'package:wejha/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';
import 'package:wejha/features/auth/register/domain/usecases/complete_registration.dart';
import 'package:wejha/features/auth/register/domain/usecases/send_verification_code.dart';
import 'package:wejha/features/auth/register/domain/usecases/verify_code.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_bloc.dart';

// Profile feature imports
import 'package:wejha/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:wejha/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:wejha/features/profile/domain/repositories/profile_repository.dart';
import 'package:wejha/features/profile/domain/usecases/get_profile.dart';
import 'package:wejha/features/profile/domain/usecases/logout.dart';
import 'package:wejha/features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => TokenManager(sl()));
  sl.registerLazySingleton(() => DeepLinkService());
  sl.registerLazySingleton(() => UrlLauncherService());
  
  // Dio client
  sl.registerLazySingleton<Dio>(() => 
    DioClient.createDio(
      baseUrl: ApiConstants.baseUrl,
      tokenManager: sl(),
    )
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
    () => RegisterRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Login
  // Bloc
  sl.registerFactory(
    () => LoginBloc(
      login: sl(),
      getGoogleAuthUrl: sl(),
      refreshToken: sl(),
      handleGoogleOAuthCallback: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetGoogleAuthUrl(sl()));
  sl.registerLazySingleton(() => RefreshToken(sl()));
  sl.registerLazySingleton(() => HandleGoogleOAuthCallback(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(dio: sl()),
  );

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
    () => ForgotPasswordRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(dio: sl()),
  );
  
  // Register API Service
  sl.registerLazySingleton(() => ApiService(
    dio: sl(),
    tokenManager: sl(),
    loginBloc: sl(),
  ));
  
  // Features - Profile
  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      logout: sl(),
    ),
  );

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
    () => ProfileRemoteDataSourceImpl(
      dio: sl(),
      apiService: sl(),
    ),
  );
  
  // Features - Splash (register after LoginBloc to avoid circular dependency)
  sl.registerFactory(
    () => SplashBloc(
      tokenManager: sl(),
      dio: sl(),
      loginBloc: sl(),
    ),
  );
} 