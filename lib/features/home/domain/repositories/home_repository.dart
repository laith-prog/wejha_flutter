import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHome();
} 