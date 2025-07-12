import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/domain/entities/login_response.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';

class HandleGoogleOAuthCallback {
  final LoginRepository repository;

  HandleGoogleOAuthCallback(this.repository);

  Future<Either<Failure, LoginResponse>> call(GoogleOAuthCallbackParams params) async {
    return await repository.handleGoogleOAuthCallback(uri: params.uri);
  }
}

class GoogleOAuthCallbackParams extends Equatable {
  final Uri uri;

  const GoogleOAuthCallbackParams({required this.uri});

  @override
  List<Object?> get props => [uri];
} 