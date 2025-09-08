import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/usecases/usecase.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';
import 'package:wejha/features/auth/google_auth/domain/repositories/google_auth_repository.dart';

class CompleteProfile implements UseCase<GoogleAuthResponseModel, CompleteProfileParams> {
  final GoogleAuthRepository repository;

  CompleteProfile(this.repository);

  @override
  Future<Either<Failure, GoogleAuthResponseModel>> call(CompleteProfileParams params) {
    return repository.completeProfile(
      userId: params.userId,
      roleId: params.roleId,
      phone: params.phone,
      gender: params.gender,
      birthday: params.birthday,
      lname: params.lname,
      photo: params.photo,
    );
  }
}

class CompleteProfileParams extends Equatable {
  final String userId;
  final int roleId;
  final String phone;
  final String gender;
  final String birthday;
  final String lname;
  final String? photo;

  const CompleteProfileParams({
    required this.userId,
    required this.roleId,
    required this.phone,
    required this.gender,
    required this.birthday,
    this.lname = '',
    this.photo,
  });

  @override
  List<Object?> get props => [userId, roleId, phone, gender, birthday, lname, photo];
} 