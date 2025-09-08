import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/features/auth/login/data/datasources/login_remote_datasource.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';
import 'package:wejha/features/auth/login/domain/entities/login_response.dart';
import 'package:wejha/features/auth/login/domain/entities/refresh_token_response.dart';
import 'package:wejha/features/auth/login/domain/entities/user.dart';
import 'package:wejha/features/auth/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.login(
          email: email,
          password: password,
        );

        // Map response model to domain entity
        final user = User(
          id: responseModel.data.user.id,
          fname: responseModel.data.user.fname,
          lname: responseModel.data.user.lname,
          role: responseModel.data.user.role,
          roleId: responseModel.data.user.roleId,
          email: responseModel.data.user.email,
          emailVerifiedAt: responseModel.data.user.emailVerifiedAt,
          phone: responseModel.data.user.phone,
          gender: responseModel.data.user.gender,
          birthday: responseModel.data.user.birthday,
          authProvider: responseModel.data.user.authProvider,
          photo: responseModel.data.user.photo,
          refreshTokenExpiresAt: responseModel.data.user.refreshTokenExpiresAt,
          createdAt: responseModel.data.user.createdAt,
          updatedAt: responseModel.data.user.updatedAt,
          deletedAt: responseModel.data.user.deletedAt,
        );

        final authToken = AuthToken(
          accessToken: responseModel.data.accessToken,
          refreshToken: responseModel.data.refreshToken,
          tokenType: responseModel.data.tokenType,
          expiresIn: responseModel.data.expiresIn,
        );

        final loginResponse = LoginResponse(
          message: responseModel.message,
          status: responseModel.status,
          user: user,
          authToken: authToken,
        );

        return Right(loginResponse);
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
  Future<Either<Failure, RefreshTokenResponse>> refreshToken({
    required String refreshToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.refreshToken(
          refreshToken: refreshToken,
        );

        final authToken = AuthToken(
          accessToken: responseModel.data.accessToken,
          refreshToken: responseModel.data.refreshToken,
          tokenType: responseModel.data.tokenType,
          expiresIn: responseModel.data.expiresIn,
        );

        final refreshTokenResponse = RefreshTokenResponse(
          message: responseModel.message,
          status: responseModel.status,
          authToken: authToken,
        );

        return Right(refreshTokenResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(
          message: 'No internet connection. Please check your connection.'));
    }
  }
} 