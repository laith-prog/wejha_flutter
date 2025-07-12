import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/domain/entities/refresh_token_response.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';

class RefreshToken {
  final LoginRepository repository;

  RefreshToken(this.repository);

  Future<Either<Failure, RefreshTokenResponse>> call(RefreshTokenParams params) async {
    return await repository.refreshToken(
      refreshToken: params.refreshToken,
    );
  }
}

class RefreshTokenParams extends Equatable {
  final String refreshToken;

  const RefreshTokenParams({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
} 