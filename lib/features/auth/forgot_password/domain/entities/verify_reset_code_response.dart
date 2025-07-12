import 'package:equatable/equatable.dart';

class VerifyResetCodeResponse extends Equatable {
  final String message;
  final String status;
  final String email;
  final bool canResetPassword;

  const VerifyResetCodeResponse({
    required this.message,
    required this.status,
    required this.email,
    required this.canResetPassword,
  });

  @override
  List<Object?> get props => [message, status, email, canResetPassword];
} 