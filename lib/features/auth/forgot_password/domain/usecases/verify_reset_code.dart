import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/verify_reset_code_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class VerifyResetCode {
  final ForgotPasswordRepository repository;

  VerifyResetCode(this.repository);

  Future<Either<Failure, VerifyResetCodeResponse>> call(VerifyResetCodeParams params) async {
    return await repository.verifyResetCode(
      email: params.email,
      code: params.code,
    );
  }
}

class VerifyResetCodeParams extends Equatable {
  final String email;
  final String code;

  const VerifyResetCodeParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
} 