import 'package:dartz/dartz.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/network/network_info.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        
        // Then clear local tokens
        await tokenManager.clearTokens();
        
        // Sign out from Firebase
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          print('Error signing out from Firebase: $e');
        }
        
        // Sign out from Google
        try {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        } catch (e) {
          print('Error signing out from Google: $e');
        }
        
        return const Right(null);
      } on ServerException catch (e) {
        // Even if the API call fails, still clear local tokens and sign out
        await tokenManager.clearTokens();
        
        // Sign out from Firebase and Google even if API fails
        try {
          await FirebaseAuth.instance.signOut();
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        } catch (e) {
          print('Error signing out from authentication services: $e');
        }
        
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        // Even if there's an unexpected error, still clear local tokens and sign out
        await tokenManager.clearTokens();
        
        // Sign out from Firebase and Google even if there's an error
        try {
          await FirebaseAuth.instance.signOut();
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        } catch (e) {
          print('Error signing out from authentication services: $e');
        }
        
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // If offline, just clear local tokens and try to sign out from auth services
      await tokenManager.clearTokens();
      
      try {
        await FirebaseAuth.instance.signOut();
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (e) {
        print('Error signing out from authentication services while offline: $e');
      }
      
      return const Left(ConnectionFailure(
        message: 'No internet connection. Please check your connection.',
      ));
    }
  }
} 