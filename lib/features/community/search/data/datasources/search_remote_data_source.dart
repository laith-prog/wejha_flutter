import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/search_models.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResponse> generalSearch({
    required String keyword,
    int? page,
    int? limit,
  });

  Future<SearchResponse> searchRealEstateForRent(
    RealEstateSearchRequest request,
  );

  Future<SearchResponse> searchRealEstateForSale(
    RealEstateSearchRequest request,
  );

  Future<SearchResponse> searchRealEstateRooms(RealEstateSearchRequest request);

  Future<SearchResponse> searchRealEstateInvestment(
    RealEstateSearchRequest request,
  );

  Future<SearchResponse> searchVehicles(VehicleSearchRequest request);

  Future<SearchResponse> searchServices(ServiceSearchRequest request);

  Future<SearchResponse> searchJobs(JobSearchRequest request);

  Future<List<CategoryModel>> getCategories();

  Future<List<SubcategoryModel>> getSubcategories({int? categoryId});

  Future<SearchResponse> getFeaturedListings({int? limit});

  Future<SearchResponse> getRecentListings({int? limit});

  Future<SearchResponse> getPopularListings({int? limit});

  Future<SearchResponse> getNearbyListings({
    required double lat,
    required double lng,
    double? radius,
    int? limit,
  });

  Future<SearchResponse> getSimilarListings(int listingId);

  Future<List<PopularSearchModel>> getPopularSearches();

  Future<List<RecentSearchModel>> getRecentSearches();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<SearchResponse> generalSearch({
    required String keyword,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.generalSearch,
        queryParameters: {
          'keyword': keyword,
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to perform general search',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchRealEstateForRent(
    RealEstateSearchRequest request,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.realEstateRentalsSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search real estate for rent',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchRealEstateForSale(
    RealEstateSearchRequest request,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.realEstateSalesSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search real estate for sale',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchRealEstateRooms(
    RealEstateSearchRequest request,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.realEstateRoomsSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search real estate rooms',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchRealEstateInvestment(
    RealEstateSearchRequest request,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.realEstateInvestmentSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search real estate investment',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchVehicles(VehicleSearchRequest request) async {
    try {
      final response = await dio.get(
        ApiConstants.vehiclesSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search vehicles',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchServices(ServiceSearchRequest request) async {
    try {
      final response = await dio.get(
        ApiConstants.servicesSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search services',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> searchJobs(JobSearchRequest request) async {
    try {
      final response = await dio.get(
        ApiConstants.jobsSearch,
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search jobs',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get categories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SubcategoryModel>> getSubcategories({int? categoryId}) async {
    try {
      final response = await dio.get(
        ApiConstants.subcategories,
        queryParameters:
            categoryId != null ? {'category_id': categoryId} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => SubcategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get subcategories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> getFeaturedListings({int? limit}) async {
    try {
      final response = await dio.get(
        ApiConstants.featuredListings,
        queryParameters: limit != null ? {'limit': limit} : null,
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get featured listings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> getRecentListings({int? limit}) async {
    try {
      final response = await dio.get(
        ApiConstants.recentListings,
        queryParameters: limit != null ? {'limit': limit} : null,
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get recent listings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> getPopularListings({int? limit}) async {
    try {
      final response = await dio.get(
        ApiConstants.popularListings,
        queryParameters: limit != null ? {'limit': limit} : null,
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get popular listings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> getNearbyListings({
    required double lat,
    required double lng,
    double? radius,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.nearbyListings,
        queryParameters: {
          'lat': lat,
          'lng': lng,
          if (radius != null) 'radius': radius,
          if (limit != null) 'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get nearby listings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SearchResponse> getSimilarListings(int listingId) async {
    try {
      final response = await dio.get(
        ApiConstants.similarListings.replaceAll('{id}', listingId.toString()),
      );

      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get similar listings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PopularSearchModel>> getPopularSearches() async {
    try {
      final response = await dio.get(ApiConstants.popularSearches);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => PopularSearchModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get popular searches',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<RecentSearchModel>> getRecentSearches() async {
    try {
      final response = await dio.get(ApiConstants.recentSearches);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => RecentSearchModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get recent searches',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
