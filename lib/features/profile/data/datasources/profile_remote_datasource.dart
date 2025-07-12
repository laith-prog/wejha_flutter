import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/network/api_service.dart';
import '../models/profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> getProfile();
  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({
    required this.dio,
    required this.apiService,
  });

  @override
  Future<ProfileResponseModel> getProfile() async {
    try {
      debugPrint('Getting user profile');

      final response = await apiService.makeAuthenticatedRequest(
        endpoint: ApiConstants.profile,
        method: 'GET',
      );

      debugPrint('Response data: $response');

      return ProfileResponseModel.fromJson(response);
    } on AuthException catch (e) {
      debugPrint('AuthException caught: ${e.message}');
      throw AuthException(message: e.message);
    } on ServerException catch (e) {
      debugPrint('ServerException caught: ${e.message}');
      throw ServerException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint('Logging out user');

      await apiService.makeAuthenticatedRequest(
        endpoint: ApiConstants.logout,
        method: 'POST',
      );

      debugPrint('Logout successful');
    } on AuthException catch (e) {
      debugPrint('AuthException caught: ${e.message}');
      throw AuthException(message: e.message);
    } on ServerException catch (e) {
      debugPrint('ServerException caught: ${e.message}');
      throw ServerException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }
} 