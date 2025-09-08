import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/features/auth/google_auth/data/datasources/google_auth_remote_data_source.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';
import 'package:wejha/features/auth/google_auth/domain/repositories/google_auth_repository.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GoogleAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });



 @override
  Future<Either<Failure, GoogleAuthResponseModel>> completeProfile({
    required String userId,
    required int roleId,
    required String phone,
    required String gender,
    required String birthday,
    String lname = '',
    String? photo,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.completeProfile(
          userId: userId,
          roleId: roleId,
          phone: phone,
          gender: gender,
          birthday: birthday,
          lname: lname,
          photo: photo,
        );
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GoogleAuthResponseModel>> firebaseGoogleAuth(String idToken) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.firebaseGoogleAuth(idToken);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }
} 