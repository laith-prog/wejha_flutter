import 'package:equatable/equatable.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';
import 'package:wejha/features/auth/login/domain/entities/user.dart';

class ResetPasswordResponse extends Equatable {
  final String message;
  final String status;
  final User user;
  final AuthToken authToken;

  const ResetPasswordResponse({
    required this.message,
    required this.status,
    required this.user,
    required this.authToken,
  });

  @override
  List<Object?> get props => [message, status, user, authToken];
} 