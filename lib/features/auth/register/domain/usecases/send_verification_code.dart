import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';

class SendVerificationCode {
  final RegisterRepository repository;

  SendVerificationCode(this.repository);

  Future<Either<Failure, String>> call(SendVerificationCodeParams params) async {
    return await repository.sendVerificationCode(
      fname: params.fname,
      lname: params.lname,
      email: params.email,
    );
  }
}

class SendVerificationCodeParams extends Equatable {
  final String fname;
  final String lname;
  final String email;

  const SendVerificationCodeParams({
    required this.fname,
    required this.lname,
    required this.email,
  });

  @override
  List<Object?> get props => [fname, lname, email];
} 