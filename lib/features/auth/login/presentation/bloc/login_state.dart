import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/data/models/login_request_model.dart';
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

// Add state for form updates
class LoginFormUpdated extends LoginState {
  final LoginRequestModel formModel;

  const LoginFormUpdated({required this.formModel});

  @override
  List<Object?> get props => [formModel];
} 