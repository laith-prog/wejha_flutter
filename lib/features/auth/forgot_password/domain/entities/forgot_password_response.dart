import 'package:equatable/equatable.dart';

class ForgotPasswordResponse extends Equatable {
  final String message;
  final String status;
  final String email;
  final int expiresIn;
  final String mailDriver;

  const ForgotPasswordResponse({
    required this.message,
    required this.status,
    required this.email,
    required this.expiresIn,
    required this.mailDriver,
  });

  @override
  List<Object?> get props => [message, status, email, expiresIn, mailDriver];
} 