import 'package:equatable/equatable.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';

class RefreshTokenResponse extends Equatable {
  final String message;
  final String status;
  final AuthToken authToken;

  const RefreshTokenResponse({
    required this.message,
    required this.status,
    required this.authToken,
  });

  @override
  List<Object?> get props => [message, status, authToken];
} 