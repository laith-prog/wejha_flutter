import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/features/home/data/datasources/home_remote_data_source.dart';
import 'package:wejha/features/home/data/models/home_models.dart';
import 'package:wejha/features/home/domain/entities/home_data.dart';
import 'package:wejha/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, HomeData>> getHome() async {
    if (await networkInfo.isConnected) {
      try {
        final HomeResponseModel model = await remoteDataSource.getHome();
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ConnectionFailure(message: 'No internet connection. Please check your connection.'));
    }
  }
} 