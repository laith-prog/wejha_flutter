import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/features/auth/forgot_password/data/models/forgot_password_request_model.dart';
import 'package:wejha/features/auth/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:wejha/features/auth/forgot_password/data/models/reset_password_request_model.dart';
import 'package:wejha/features/auth/forgot_password/data/models/reset_password_response_model.dart';
import 'package:wejha/features/auth/forgot_password/data/models/verify_reset_code_request_model.dart';
import 'package:wejha/features/auth/forgot_password/data/models/verify_reset_code_response_model.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<ForgotPasswordResponseModel> forgotPassword({
    required String email,
  });

  Future<VerifyResetCodeResponseModel> verifyResetCode({
    required String email,
    required String code,
  });

  Future<ResetPasswordResponseModel> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}

class ForgotPasswordRemoteDataSourceImpl implements ForgotPasswordRemoteDataSource {
  final Dio dio;

  ForgotPasswordRemoteDataSourceImpl({required this.dio});

  @override
  Future<ForgotPasswordResponseModel> forgotPassword({
    required String email,
  }) async {
    try {
      debugPrint('Sending forgot password request for email: $email');
      
      final requestModel = ForgotPasswordRequestModel(
        email: email,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return ForgotPasswordResponseModel.fromJson(response.data);
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
      
      // Handle 404 error specifically for "User not found"
      if (e.response?.statusCode == 404) {
        final errorMessage = e.response?.data['message'] ?? 'البريد الإلكتروني غير مسجل';
        throw ServerException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      
      if (e.response?.statusCode == 422) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Invalid email',
          errors: e.response?.data['errors'],
        );
      }
      
      // For any other error responses, extract message from response if available
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(
          message: e.response?.data['message'],
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

  @override
  Future<VerifyResetCodeResponseModel> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      debugPrint('Verifying reset code for email: $email');
      
      final requestModel = VerifyResetCodeRequestModel(
        email: email,
        code: code,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.verifyResetCode,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return VerifyResetCodeResponseModel.fromJson(response.data);
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
      
      // Handle 404 error
      if (e.response?.statusCode == 404) {
        final errorMessage = e.response?.data['message'] ?? 'البريد الإلكتروني غير مسجل';
        throw ServerException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      
      if (e.response?.statusCode == 422 || e.response?.statusCode == 400) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Invalid verification code',
          errors: e.response?.data['errors'],
        );
      }
      
      // For any other error responses, extract message from response if available
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(
          message: e.response?.data['message'],
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

  @override
  Future<ResetPasswordResponseModel> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      debugPrint('Resetting password for email: $email');
      
      final requestModel = ResetPasswordRequestModel(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.resetPassword,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return ResetPasswordResponseModel.fromJson(response.data);
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
      
      // Handle 404 error
      if (e.response?.statusCode == 404) {
        final errorMessage = e.response?.data['message'] ?? 'البريد الإلكتروني غير مسجل';
        throw ServerException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      
      if (e.response?.statusCode == 422) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Invalid password reset request',
          errors: e.response?.data['errors'],
        );
      }
      
      // For any other error responses, extract message from response if available
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(
          message: e.response?.data['message'],
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