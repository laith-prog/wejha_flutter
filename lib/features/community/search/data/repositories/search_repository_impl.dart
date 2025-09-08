import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_models.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResults>> generalSearch({
    required String keyword,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.generalSearch(
        keyword: keyword,
        page: page,
        limit: limit,
      );
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchRealEstateForRent(
    RealEstateSearchParams params,
  ) async {
    try {
      final request = _toRealEstateSearchRequest(params);
      final response = await remoteDataSource.searchRealEstateForRent(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchRealEstateForSale(
    RealEstateSearchParams params,
  ) async {
    try {
      final request = _toRealEstateSearchRequest(params);
      final response = await remoteDataSource.searchRealEstateForSale(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchRealEstateRooms(
    RealEstateSearchParams params,
  ) async {
    try {
      final request = _toRealEstateSearchRequest(params);
      final response = await remoteDataSource.searchRealEstateRooms(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchRealEstateInvestment(
    RealEstateSearchParams params,
  ) async {
    try {
      final request = _toRealEstateSearchRequest(params);
      final response = await remoteDataSource.searchRealEstateInvestment(
        request,
      );
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchVehicles(
    VehicleSearchParams params,
  ) async {
    try {
      final request = _toVehicleSearchRequest(params);
      final response = await remoteDataSource.searchVehicles(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchServices(
    ServiceSearchParams params,
  ) async {
    try {
      final request = _toServiceSearchRequest(params);
      final response = await remoteDataSource.searchServices(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchJobs(
    JobSearchParams params,
  ) async {
    try {
      final request = _toJobSearchRequest(params);
      final response = await remoteDataSource.searchJobs(request);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories.map(_toCategoryEntity).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Subcategory>>> getSubcategories({
    int? categoryId,
  }) async {
    try {
      final subcategories = await remoteDataSource.getSubcategories(
        categoryId: categoryId,
      );
      return Right(subcategories.map(_toSubcategoryEntity).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> getFeaturedListings({
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getFeaturedListings(limit: limit);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> getRecentListings({int? limit}) async {
    try {
      final response = await remoteDataSource.getRecentListings(limit: limit);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> getPopularListings({
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getPopularListings(limit: limit);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> getNearbyListings({
    required double lat,
    required double lng,
    double? radius,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getNearbyListings(
        lat: lat,
        lng: lng,
        radius: radius,
        limit: limit,
      );
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> getSimilarListings(
    int listingId,
  ) async {
    try {
      final response = await remoteDataSource.getSimilarListings(listingId);
      return Right(_toSearchResults(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PopularSearch>>> getPopularSearches() async {
    try {
      final popularSearches = await remoteDataSource.getPopularSearches();
      return Right(popularSearches.map(_toPopularSearchEntity).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecentSearch>>> getRecentSearches() async {
    try {
      final recentSearches = await remoteDataSource.getRecentSearches();
      return Right(recentSearches.map(_toRecentSearchEntity).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Helper methods to convert between domain entities and data models
  RealEstateSearchRequest _toRealEstateSearchRequest(
    RealEstateSearchParams params,
  ) {
    return RealEstateSearchRequest(
      query: params.query,
      city: params.city,
      area: params.area,
      lat: params.lat,
      lng: params.lng,
      radius: params.radius,
      limit: params.limit,
      page: params.page,
      propertyType: params.propertyType,
      minPrice: params.priceMin,
      maxPrice: params.priceMax,
      rooms: params.roomNumber?.toString(),
      bathrooms: params.bathrooms,
      minArea: params.propertyAreaMin,
      maxArea: params.propertyAreaMax,
      furnished: params.furnished,
      hasParking: params.hasParking,
      hasGarden: params.hasGarden,
      hasPool: params.hasPool,
      hasElevator: params.hasElevator,
      amenities: params.amenities,
    );
  }

  VehicleSearchRequest _toVehicleSearchRequest(VehicleSearchParams params) {
    return VehicleSearchRequest(
      query: params.query,
      city: params.city,
      area: params.area,
      lat: params.lat,
      lng: params.lng,
      radius: params.radius,
      limit: params.limit,
      page: params.page,
      make: params.make,
      model: params.model,
      minYear: params.yearMin,
      maxYear: params.yearMax,
      minPrice: params.priceMin,
      maxPrice: params.priceMax,
      maxMileage: params.mileageMax,
      color: params.color,
      transmission: params.transmission,
      fuelType: params.fuelType,
      bodyType: params.bodyType,
      condition: params.condition,
      features: params.vehicleFeatures,
    );
  }

  ServiceSearchRequest _toServiceSearchRequest(ServiceSearchParams params) {
    return ServiceSearchRequest(
      query: params.query,
      city: params.city,
      area: params.area,
      lat: params.lat,
      lng: params.lng,
      radius: params.radius,
      limit: params.limit,
      page: params.page,
      subcategoryId: params.subcategoryId,
      minPrice: params.priceMin,
      maxPrice: params.priceMax,
      priceType: params.priceType,
      availableDay:
          params.availability?.isNotEmpty == true
              ? params.availability!.first
              : null,
      minExperience: params.experienceYearsMin,
      isMobile: params.isMobile,
    );
  }

  JobSearchRequest _toJobSearchRequest(JobSearchParams params) {
    return JobSearchRequest(
      query: params.query,
      city: params.city,
      area: params.area,
      lat: params.lat,
      lng: params.lng,
      radius: params.radius,
      limit: params.limit,
      page: params.page,
      jobType: params.jobType,
      attendanceType: params.attendanceType,
      industry: params.jobCategory,
      minSalary: params.salaryMin,
      maxSalary: params.salaryMax,
      experienceLevel: params.experienceYearsMin?.toString(),
      educationLevel: params.educationLevel,
      companySize: params.companySize,
      benefits: params.benefits,
    );
  }

  SearchResults _toSearchResults(SearchResponse response) {
    return SearchResults(
      items: response.data.map(_toSearchResultEntity).toList(),
      currentPage: response.currentPage,
      lastPage: response.lastPage,
      perPage: response.perPage,
      total: response.total,
      nextPageUrl: response.nextPageUrl,
      prevPageUrl: response.prevPageUrl,
    );
  }

  SearchResult _toSearchResultEntity(SearchResultItem item) {
    return SearchResult(
      id: item.id,
      title: item.title,
      description: item.description,
      price: item.price,
      priceType: item.priceType,
      currency: item.currency,
      phoneNumber: item.phoneNumber,
      purpose: item.purpose,
      subcategoryId: item.subcategoryId,
      lat: item.lat,
      lng: item.lng,
      city: item.city,
      area: item.area,
      createdAt: DateTime.parse(item.createdAt),
      updatedAt: DateTime.parse(item.updatedAt),
      images: item.images,
      metadata: item.metadata,
    );
  }

  Category _toCategoryEntity(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      displayName: model.displayName,
      createdAt:
          model.createdAt != null ? DateTime.parse(model.createdAt!) : null,
      updatedAt:
          model.updatedAt != null ? DateTime.parse(model.updatedAt!) : null,
    );
  }

  Subcategory _toSubcategoryEntity(SubcategoryModel model) {
    return Subcategory(
      id: model.id,
      categoryId: model.categoryId,
      name: model.name,
      displayName: model.displayName,
      createdAt:
          model.createdAt != null ? DateTime.parse(model.createdAt!) : null,
      updatedAt:
          model.updatedAt != null ? DateTime.parse(model.updatedAt!) : null,
    );
  }

  PopularSearch _toPopularSearchEntity(PopularSearchModel model) {
    return PopularSearch(
      query: model.query,
      count: model.count,
      category: model.category,
    );
  }

  RecentSearch _toRecentSearchEntity(RecentSearchModel model) {
    return RecentSearch(
      query: model.query,
      timestamp: DateTime.parse(model.timestamp),
      category: model.category,
    );
  }
}
