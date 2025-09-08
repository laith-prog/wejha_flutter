import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/usecases/usecase.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';
import 'package:wejha/features/auth/google_auth/domain/repositories/google_auth_repository.dart';

class FirebaseGoogleAuth implements UseCase<GoogleAuthResponseModel, FirebaseGoogleAuthParams> {
  final GoogleAuthRepository repository;

  FirebaseGoogleAuth(this.repository);

  @override
  Future<Either<Failure, GoogleAuthResponseModel>> call(FirebaseGoogleAuthParams params) {
    return repository.firebaseGoogleAuth(params.idToken);
  }
}

class FirebaseGoogleAuthParams extends Equatable {
  final String idToken;

  const FirebaseGoogleAuthParams({required this.idToken});

  @override
  List<Object?> get props => [idToken];
} 