import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/domain/entities/register_response.dart';

abstract class RegisterRepository {
  Future<Either<Failure, String>> sendVerificationCode({
    required String fname,
    required String lname,
    required String email,
  });

  Future<Either<Failure, String>> verifyCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, RegisterResponse>> completeRegistration({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
    required String birthday,
    String? roleId,
    String? photo,
  });
} 