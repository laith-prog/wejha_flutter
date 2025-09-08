import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/usecases/usecase.dart';
import 'package:wejha/features/home/domain/entities/home_data.dart';
import 'package:wejha/features/home/domain/repositories/home_repository.dart';

class GetHomeData implements UseCase<HomeData, NoParams> {
  final HomeRepository repository;
  GetHomeData(this.repository);

  @override
  Future<Either<Failure, HomeData>> call(NoParams params) async {
    return repository.getHome();
  }
} 