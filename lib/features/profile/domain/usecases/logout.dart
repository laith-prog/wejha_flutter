import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import '../repositories/profile_repository.dart';

class Logout {
  final ProfileRepository repository;

  Logout(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
} 