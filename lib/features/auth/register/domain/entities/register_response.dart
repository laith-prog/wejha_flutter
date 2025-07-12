import 'package:equatable/equatable.dart';
import 'user.dart';

class RegisterResponse extends Equatable {
  final String message;
  final String status;
  final RegisterResponseData data;

  const RegisterResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  @override
  List<Object?> get props => [message, status, data];
}

class RegisterResponseData extends Equatable {
  final User user;
  final Tokens tokens;

  const RegisterResponseData({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object?> get props => [user, tokens];
}

class Tokens extends Equatable {
  final String accessToken;
  final String refreshToken;

  const Tokens({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];
} 