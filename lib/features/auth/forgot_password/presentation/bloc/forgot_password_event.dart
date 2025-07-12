import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendForgotPasswordEmailEvent extends ForgotPasswordEvent {
  final String email;

  const SendForgotPasswordEmailEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class VerifyResetCodeEvent extends ForgotPasswordEvent {
  final String email;
  final String code;

  const VerifyResetCodeEvent({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordEvent({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, password, passwordConfirmation];
} 