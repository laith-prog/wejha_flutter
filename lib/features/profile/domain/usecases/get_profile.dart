import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import '../entities/profile_response.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, ProfileResponse>> call() async {
    return await repository.getProfile();
  }
} 