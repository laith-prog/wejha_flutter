import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/failures.dart';
import '../entities/profile_response.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, void>> logout();
} 