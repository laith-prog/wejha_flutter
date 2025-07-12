import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/domain/entities/register_response.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';

class CompleteRegistration {
  final RegisterRepository repository;

  CompleteRegistration(this.repository);

  Future<Either<Failure, RegisterResponse>> call(
    CompleteRegistrationParams params,
  ) async {
    return await repository.completeRegistration(
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      phone: params.phone,
      gender: params.gender,
      birthday: params.birthday,
      roleId: params.roleId,
      photo: params.photo,
    );
  }
}

class CompleteRegistrationParams extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;
  final String birthday;
  final String? roleId;
  final String? photo;

  const CompleteRegistrationParams({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.gender,
    required this.birthday,
    this.roleId,
    this.photo,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,
    phone,
    gender,
    birthday,
    roleId,
    photo,
  ];
}
