import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/data/models/register_request_model.dart';
import 'package:wejha/features/auth/register/domain/entities/register_response.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class VerificationCodeSending extends RegisterState {}

class VerificationCodeSent extends RegisterState {
  final String message;

  const VerificationCodeSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class VerificationCodeError extends RegisterState {
  final Failure failure;

  const VerificationCodeError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CodeVerifying extends RegisterState {}

class CodeVerified extends RegisterState {
  final String message;

  const CodeVerified({required this.message});

  @override
  List<Object?> get props => [message];
}

class CodeVerificationError extends RegisterState {
  final Failure failure;

  const CodeVerificationError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RegistrationCompleting extends RegisterState {}

class RegistrationCompleted extends RegisterState {
  final RegisterResponse registerResponse;

  const RegistrationCompleted({required this.registerResponse});

  @override
  List<Object?> get props => [registerResponse];
}

class RegistrationError extends RegisterState {
  final Failure failure;

  const RegistrationError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Add state for form updates
class RegisterFormUpdated extends RegisterState {
  final RegisterRequestModel formModel;

  const RegisterFormUpdated({required this.formModel});

  @override
  List<Object?> get props => [formModel];
} 