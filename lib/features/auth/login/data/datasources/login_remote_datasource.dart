import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/features/auth/login/data/models/google_auth_response_model.dart';
import 'package:wejha/features/auth/login/data/models/login_request_model.dart';
import 'package:wejha/features/auth/login/data/models/login_response_model.dart';
import 'package:wejha/features/auth/login/data/models/refresh_token_request_model.dart';
import 'package:wejha/features/auth/login/data/models/refresh_token_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<GoogleAuthResponseModel> getGoogleAuthUrl();
  
  Future<RefreshTokenResponseModel> refreshToken({
    required String refreshToken,
  });
  
  // Add method for handling Google OAuth callbacks
  Future<LoginResponseModel> handleGoogleOAuthCallback({
    required Uri uri,
  });
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Logging in with email: $email');
      
      final requestModel = LoginRequestModel(
        email: email,
        password: password,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.login,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException response: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw ServerException(
          message: 'Server is taking too long to respond. Please try again later.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          message: 'Cannot connect to the server. Please check your internet connection.',
        );
      }
      
      if (e.response?.statusCode == 422 || e.response?.statusCode == 401) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Invalid credentials',
          errors: e.response?.data['errors'],
        );
      }
      throw ServerException(
        message: e.message ?? 'Server error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<GoogleAuthResponseModel> getGoogleAuthUrl() async {
    try {
      debugPrint('Getting Google auth URL');

      final response = await dio.get(ApiConstants.googleAuth);

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return GoogleAuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');
      throw ServerException(
        message: e.message ?? 'Server error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<RefreshTokenResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      debugPrint('Refreshing token');
      
      final requestModel = RefreshTokenRequestModel(
        refreshToken: refreshToken,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return RefreshTokenResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException response: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        throw AuthException(
          message: e.response?.data['message'] ?? 'Invalid or expired refresh token',
        );
      }
      throw ServerException(
        message: e.message ?? 'Server error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LoginResponseModel> handleGoogleOAuthCallback({
    required Uri uri,
  }) async {
    try {
      debugPrint('Handling Google OAuth callback: ${uri.toString()}');
      
      String? code;
      
      // Handle different URL formats
      if (uri.path.contains('/api/v1/auth/google')) {
        // Direct API URL format
        code = uri.queryParameters['code'];
        debugPrint('Extracted code from API URL: ${code?.substring(0, min(10, code.length))}...');
      } else if (uri.path.contains('google/callback')) {
        // Callback URL format
        code = uri.queryParameters['code'];
        debugPrint('Extracted code from callback URL: ${code?.substring(0, min(10, code.length))}...');
      }
      
      if (code == null) {
        throw ServerException(
          message: 'Authorization code not found in the callback URL',
        );
      }
      
      // Create a new Dio instance with different settings for this specific request
      final callbackDio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeout),
        sendTimeout: const Duration(seconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'Wejha-App/1.0', // Add a custom user agent
        },
      ));
      
      // Send the code to the server
      debugPrint('Sending code to server: ${ApiConstants.googleAuthCallback}');
      final response = await callbackDio.post(
        ApiConstants.googleAuthCallback,
        data: {'code': code},
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException response: ${e.response?.data}');
      
      if (e.response?.statusCode == 403) {
        throw ServerException(
          message: 'Access forbidden. The server rejected the request. Please try again later.',
          statusCode: e.response?.statusCode,
        );
      }
      
      throw ServerException(
        message: e.message ?? 'Server error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }
} 