import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/reset_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ResetPassword {
  final ForgotPasswordRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, ResetPasswordResponse>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, password, passwordConfirmation];
} 