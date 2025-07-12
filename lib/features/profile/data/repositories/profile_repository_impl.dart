import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/core/services/token_manager.dart';
import '../../domain/entities/profile_response.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final TokenManager tokenManager;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final profileResponse = await remoteDataSource.getProfile();
        return Right(profileResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(
        message: 'No internet connection. Please check your connection.',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        // First call the API to logout
        await remoteDataSource.logout();
        
        // Then clear local tokens regardless of API response
        await tokenManager.clearTokens();
        
        return const Right(null);
      } on ServerException catch (e) {
        // Even if the API call fails, still clear local tokens
        await tokenManager.clearTokens();
        
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        // Even if there's an unexpected error, still clear local tokens
        await tokenManager.clearTokens();
        
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // If offline, just clear local tokens
      await tokenManager.clearTokens();
      
      return const Left(ConnectionFailure(
        message: 'No internet connection. Please check your connection.',
      ));
    }
  }
} 