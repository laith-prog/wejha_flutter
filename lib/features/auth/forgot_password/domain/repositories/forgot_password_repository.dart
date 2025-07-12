import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/forgot_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/reset_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/verify_reset_code_response.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, VerifyResetCodeResponse>> verifyResetCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, ResetPasswordResponse>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  });
} 