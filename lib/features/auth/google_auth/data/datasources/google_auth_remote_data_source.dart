import 'package:dio/dio.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'dart:io';
import 'dart:convert';

abstract class GoogleAuthRemoteDataSource {
  /// Calls the API to get the Google Auth URL
  /// Throws a [ServerException] for all error codes.

  /// Handles Firebase Google authentication with ID token
  /// Throws a [ServerException] for all error codes.
  Future<GoogleAuthResponseModel> firebaseGoogleAuth(String idToken);
  
  /// Completes the user profile after Google registration
  /// Throws a [ServerException] for all error codes.
  Future<GoogleAuthResponseModel> completeProfile({
    required String userId,
    required int roleId,
    required String phone,
    required String gender,
    required String birthday,
    String lname = '',
    String? photo,
  });
}

class GoogleAuthRemoteDataSourceImpl implements GoogleAuthRemoteDataSource {
  final Dio dio;

  GoogleAuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<GoogleAuthResponseModel> firebaseGoogleAuth(String idToken) async {
    try {
      debugPrint('Sending Firebase ID token to backend: ${idToken.substring(0, math.min(20, idToken.length))}...');
      
      final response = await dio.post(
        ApiConstants.firebaseGoogleAuth,
        data: {
          'idToken': idToken,
        },
        options: Options(
          headers: {
            ...ApiConstants.headers,
            'Authorization': 'Bearer $idToken', // Try adding token in header as well
          },
        ),
      );
      
      if (response.statusCode == 200) {
        debugPrint('Firebase Google Auth successful');
        // Print the full response for debugging
        debugPrint('Response data: ${response.data}');
        
        try {
          return GoogleAuthResponseModel.fromJson(response.data);
        } catch (parseError) {
          debugPrint('Error parsing response: $parseError');
          throw ServerException(
            message: 'Failed to parse server response: $parseError',
          );
        }
      } else {
        debugPrint('Firebase Google Auth failed with status ${response.statusCode}');
        throw ServerException(
          message: response.data['message'] ?? 'Failed to authenticate with Firebase',
        );
      }
    } catch (e) {
      debugPrint('Firebase Google Auth exception: $e');
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<GoogleAuthResponseModel> completeProfile({
    required String userId,
    required int roleId,
    required String phone,
    required String gender,
    required String birthday,
    String lname = '',
    String? photo,
  }) async {
    try {
      // Create form data for multipart request
      final formData = FormData.fromMap({
        'user_id': userId,
        'role_id': roleId,
        'phone': phone,
        'gender': gender,
        'birthday': birthday,
        'lname': lname,
      });
      
      // Add photo if provided
      if (photo != null && photo.isNotEmpty) {
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(
            photo,
            filename: photo.split('/').last,
          ),
        ));
      }
      
      final response = await dio.post(
        ApiConstants.completeProfile,
        data: formData,
        options: Options(
          headers: {
            ...ApiConstants.headers,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        debugPrint('Profile completion successful');
        // Print the full response for debugging
        debugPrint('Response data: ${response.data}');
        
        try {
          return GoogleAuthResponseModel.fromJson(response.data);
        } catch (parseError) {
          debugPrint('Error parsing response: $parseError');
          throw ServerException(
            message: 'Failed to parse server response: $parseError',
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to complete profile',
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
} 