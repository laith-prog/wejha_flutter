import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/forgot_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPassword {
  final ForgotPasswordRepository repository;

  ForgotPassword(this.repository);

  Future<Either<Failure, ForgotPasswordResponse>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(
      email: params.email,
    );
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
} 