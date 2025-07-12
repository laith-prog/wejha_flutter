import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';

class ApiService {
  final Dio dio;
  final TokenManager tokenManager;
  final LoginBloc loginBloc;

  ApiService({
    required this.dio,
    required this.tokenManager,
    required this.loginBloc,
  });

  /// Example of a protected API call that handles token refresh
  Future<dynamic> makeAuthenticatedRequest({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Check if token needs to be refreshed
      await tokenManager.refreshTokenIfNeeded(loginBloc);

      // Make the API call
      Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get(
            endpoint,
            queryParameters: queryParameters,
          );
          break;
        case 'POST':
          response = await dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case 'PUT':
          response = await dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case 'DELETE':
          response = await dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        default:
          throw ServerException(message: 'Unsupported HTTP method: $method');
      }

      return response.data;
    } on DioException catch (e) {
      // Handle authentication errors
      if (e.response?.statusCode == 401) {
        debugPrint('Authentication error: ${e.message}');
        // Clear tokens if authentication fails
        await tokenManager.clearTokens();
        throw AuthException(message: 'Authentication failed. Please log in again.');
      }
      
      // Handle other Dio errors
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('Error in makeAuthenticatedRequest: $e');
      throw ServerException(message: e.toString());
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data['message'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'Cannot connect to the server. Please check your internet connection.',
        );
      default:
        return ServerException(
          message: e.message ?? 'An unexpected error occurred',
        );
    }
  }
} 