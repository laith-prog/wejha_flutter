import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/features/auth/forgot_password/data/datasources/forgot_password_remote_datasource.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/forgot_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/reset_password_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/entities/verify_reset_code_response.dart';
import 'package:wejha/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';
import 'package:wejha/features/auth/login/domain/entities/user.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ForgotPasswordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.forgotPassword(
          email: email,
        );

        final forgotPasswordResponse = ForgotPasswordResponse(
          message: responseModel.message,
          status: responseModel.status,
          email: responseModel.data.email,
          expiresIn: responseModel.data.expiresIn,
          mailDriver: responseModel.data.mailDriver,
        );

        return Right(forgotPasswordResponse);
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
  Future<Either<Failure, VerifyResetCodeResponse>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.verifyResetCode(
          email: email,
          code: code,
        );

        final verifyResetCodeResponse = VerifyResetCodeResponse(
          message: responseModel.message,
          status: responseModel.status,
          email: responseModel.data.email,
          canResetPassword: responseModel.data.canResetPassword,
        );

        return Right(verifyResetCodeResponse);
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
  Future<Either<Failure, ResetPasswordResponse>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.resetPassword(
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
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

        final resetPasswordResponse = ResetPasswordResponse(
          message: responseModel.message,
          status: responseModel.status,
          user: user,
          authToken: authToken,
        );

        return Right(resetPasswordResponse);
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