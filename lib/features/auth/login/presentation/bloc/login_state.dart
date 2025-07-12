import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/data/models/login_request_model.dart';
import 'package:wejha/features/auth/login/domain/entities/google_auth_response.dart';
import 'package:wejha/features/auth/login/domain/entities/login_response.dart';
import 'package:wejha/features/auth/login/domain/entities/refresh_token_response.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  const LoginSuccess({required this.loginResponse});

  @override
  List<Object?> get props => [loginResponse];
}

class LoginError extends LoginState {
  final Failure failure;

  const LoginError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GoogleAuthLoading extends LoginState {}

class GoogleAuthSuccess extends LoginState {
  final GoogleAuthResponse googleAuthResponse;

  const GoogleAuthSuccess({required this.googleAuthResponse});

  @override
  List<Object?> get props => [googleAuthResponse];
}

class GoogleAuthError extends LoginState {
  final Failure failure;

  const GoogleAuthError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class LogoutLoading extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutError extends LoginState {
  final Failure failure;

  const LogoutError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RefreshTokenLoading extends LoginState {}

class RefreshTokenSuccess extends LoginState {
  final RefreshTokenResponse refreshTokenResponse;

  const RefreshTokenSuccess({required this.refreshTokenResponse});

  @override
  List<Object?> get props => [refreshTokenResponse];
}

class RefreshTokenError extends LoginState {
  final Failure failure;

  const RefreshTokenError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Add state for processing Google OAuth callback
class GoogleOAuthCallbackProcessing extends LoginState {}

// Add state for successful Google OAuth callback
class GoogleOAuthCallbackSuccess extends LoginState {
  final LoginResponse loginResponse;

  const GoogleOAuthCallbackSuccess({required this.loginResponse});

  @override
  List<Object?> get props => [loginResponse];
}

// Add state for failed Google OAuth callback
class GoogleOAuthCallbackError extends LoginState {
  final Failure failure;

  const GoogleOAuthCallbackError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Add state for form updates
class LoginFormUpdated extends LoginState {
  final LoginRequestModel formModel;

  const LoginFormUpdated({required this.formModel});

  @override
  List<Object?> get props => [formModel];
} 