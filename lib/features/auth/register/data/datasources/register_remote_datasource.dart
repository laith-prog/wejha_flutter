import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/features/auth/register/data/models/register_request_model.dart';
import 'package:wejha/features/auth/register/data/models/register_response_model.dart';
import 'package:wejha/features/auth/register/data/models/verification_code_request_model.dart';
import 'package:wejha/features/auth/register/data/models/verification_request_model.dart';
import 'package:wejha/features/auth/register/data/models/verification_response_model.dart';

abstract class RegisterRemoteDataSource {
  Future<VerificationResponseModel> sendVerificationCode({
    required String fname,
    required String lname,
    required String email,
  });

  Future<VerificationResponseModel> verifyCode({
    required String email,
    required String code,
  });

  Future<RegisterResponseModel> completeRegistration({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
    required String birthday,
    String? roleId,
    String? photo,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final Dio dio;

  RegisterRemoteDataSourceImpl({required this.dio});

  @override
  Future<VerificationResponseModel> sendVerificationCode({
    required String fname,
    required String lname,
    required String email,
  }) async {
    try {
      debugPrint('Sending verification code to email: $email');

      final requestModel = VerificationRequestModel(
        fname: fname,
        lname: lname,
        email: email,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.sendVerificationCode,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerificationResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');

      if (e.response?.statusCode == 422) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Validation error',
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
  Future<VerificationResponseModel> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      debugPrint('Verifying code for email: $email');

      final requestModel = VerificationCodeRequestModel(
        email: email,
        code: code,
      );

      // Print the request payload
      debugPrint('Request payload: ${jsonEncode(requestModel.toJson())}');

      final response = await dio.post(
        ApiConstants.verifyCode,
        data: requestModel.toJson(),
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerificationResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException caught: ${e.message}');

      if (e.response?.statusCode == 422) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Validation error',
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
  Future<RegisterResponseModel> completeRegistration({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
    required String birthday,
    String? roleId,
    String? photo,
  }) async {
    try {
      debugPrint('Completing registration for email: $email');

      // Create form data for multipart request
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'gender': gender,
        'birthday': birthday,
        if (roleId != null) 'role_id': roleId,
        if (photo != null) 'photo': await MultipartFile.fromFile(
          photo,
          filename: photo.split('/').last,
        ),
      });

      // Print the request payload (excluding file content for brevity)
      debugPrint('Request payload: ${formData.fields}');

      final response = await dio.post(
        ApiConstants.completeRegistration,
        data: formData,
      );

      debugPrint('Response received: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
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
      
      // Handle validation errors (422)
      if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Validation error';
        final errors = e.response?.data['errors'];
        throw ValidationException(
          message: message,
          errors: errors,
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
      if (e is ValidationException) {
        rethrow; // Re-throw validation exceptions as is
      }
      
      debugPrint('General exception caught: $e');
      throw ServerException(message: e.toString());
    }
  }
}
