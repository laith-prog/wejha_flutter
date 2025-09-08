import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/error/exceptions.dart';
import 'package:wejha/features/home/data/models/home_models.dart';

abstract class HomeRemoteDataSource {
  Future<HomeResponseModel> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<HomeResponseModel> getHome() async {
    try {
      final response = await dio.get(ApiConstants.communityHome);
      if (response.statusCode == 200) {
        if (kDebugMode) debugPrint('Home response: ${response.data}');
        return HomeResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(message: response.data['message'] ?? 'Failed to load home', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error', statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
} 