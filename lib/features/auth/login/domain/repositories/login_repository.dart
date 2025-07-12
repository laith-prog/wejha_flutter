import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/domain/entities/google_auth_response.dart';
import 'package:wejha/features/auth/login/domain/entities/login_response.dart';
import 'package:wejha/features/auth/login/domain/entities/refresh_token_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, GoogleAuthResponse>> getGoogleAuthUrl();
  
  Future<Either<Failure, RefreshTokenResponse>> refreshToken({
    required String refreshToken,
  });
  
  // Add method for handling Google OAuth callbacks
  Future<Either<Failure, LoginResponse>> handleGoogleOAuthCallback({
    required Uri uri,
  });
} 