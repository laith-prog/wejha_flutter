import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/domain/entities/google_auth_response.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';

class GetGoogleAuthUrl {
  final LoginRepository repository;

  GetGoogleAuthUrl(this.repository);

  Future<Either<Failure, GoogleAuthResponse>> call() async {
    return await repository.getGoogleAuthUrl();
  }
} 