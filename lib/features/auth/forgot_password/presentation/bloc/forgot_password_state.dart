import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/forgot_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/reset_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/verify_reset_code_response.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

// States for sending forgot password email
class SendingForgotPasswordEmail extends ForgotPasswordState {}

class ForgotPasswordEmailSent extends ForgotPasswordState {
  final ForgotPasswordResponse response;

  const ForgotPasswordEmailSent({required this.response});

  @override
  List<Object?> get props => [response];
}

class ForgotPasswordEmailError extends ForgotPasswordState {
  final Failure failure;

  const ForgotPasswordEmailError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// States for verifying reset code
class VerifyingResetCode extends ForgotPasswordState {}

class ResetCodeVerified extends ForgotPasswordState {
  final VerifyResetCodeResponse response;

  const ResetCodeVerified({required this.response});

  @override
  List<Object?> get props => [response];
}

class ResetCodeError extends ForgotPasswordState {
  final Failure failure;

  const ResetCodeError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// States for resetting password
class ResettingPassword extends ForgotPasswordState {}

class PasswordResetSuccess extends ForgotPasswordState {
  final ResetPasswordResponse response;

  const PasswordResetSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class PasswordResetError extends ForgotPasswordState {
  final Failure failure;

  const PasswordResetError({required this.failure});

  @override
  List<Object?> get props => [failure];
} 