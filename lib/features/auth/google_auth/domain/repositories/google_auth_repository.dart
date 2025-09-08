import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';

abstract class GoogleAuthRepository {
  Future<Either<Failure, GoogleAuthResponseModel>> completeProfile({
    required String userId,
    required int roleId,
    required String phone,
    required String gender,
    required String birthday,
    String lname = '',
    String? photo,
  });

  Future<Either<Failure, GoogleAuthResponseModel>> firebaseGoogleAuth(String idToken);
} 