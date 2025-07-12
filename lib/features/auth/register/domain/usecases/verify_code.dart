import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';

class VerifyCode {
  final RegisterRepository repository;

  VerifyCode(this.repository);

  Future<Either<Failure, String>> call(VerifyCodeParams params) async {
    return await repository.verifyCode(
      email: params.email,
      code: params.code,
    );
  }
}

class VerifyCodeParams extends Equatable {
  final String email;
  final String code;

  const VerifyCodeParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
} 