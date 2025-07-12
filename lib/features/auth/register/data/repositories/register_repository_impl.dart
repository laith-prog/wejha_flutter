import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/features/auth/register/data/datasources/register_remote_datasource.dart';
import 'package:wejha/features/auth/register/domain/entities/register_response.dart';
import 'package:wejha/features/auth/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> sendVerificationCode({
    required String fname,
    required String lname,
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendVerificationCode(
          fname: fname,
          lname: lname,
          email: email,
        );
        return Right(response.message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(
          message: 'No internet connection. Please check your connection.'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCode({
    required String email,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyCode(
          email: email,
          code: code,
        );
        return Right(response.message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(
          message: 'No internet connection. Please check your connection.'));
    }
  }

  @override
  Future<Either<Failure, RegisterResponse>> completeRegistration({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
    required String birthday,
    String? roleId,
    String? photo,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.completeRegistration(
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          phone: phone,
          gender: gender,
          birthday: birthday,
          roleId: roleId,
          photo: photo,
        );

        // Convert response model to domain entity using toEntity method
        return Right(responseModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(
          message: 'No internet connection. Please check your connection.'));
    }
  }
} 