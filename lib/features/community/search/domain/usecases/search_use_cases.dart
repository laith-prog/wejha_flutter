import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_entities.dart';
import '../repositories/search_repository.dart';

// General Search Use Case
class GeneralSearch extends UseCase<SearchResults, GeneralSearchParams> {
  final SearchRepository repository;

  GeneralSearch(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GeneralSearchParams params,
  ) async {
    return await repository.generalSearch(
      keyword: params.keyword,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GeneralSearchParams {
  final String keyword;
  final int? page;
  final int? limit;

  const GeneralSearchParams({required this.keyword, this.page, this.limit});
}

// Real Estate Search Use Cases
class SearchRealEstateForRent
    extends UseCase<SearchResults, RealEstateSearchParams> {
  final SearchRepository repository;

  SearchRealEstateForRent(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    RealEstateSearchParams params,
  ) async {
    return await repository.searchRealEstateForRent(params);
  }
}

class SearchRealEstateForSale
    extends UseCase<SearchResults, RealEstateSearchParams> {
  final SearchRepository repository;

  SearchRealEstateForSale(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    RealEstateSearchParams params,
  ) async {
    return await repository.searchRealEstateForSale(params);
  }
}

class SearchRealEstateRooms
    extends UseCase<SearchResults, RealEstateSearchParams> {
  final SearchRepository repository;

  SearchRealEstateRooms(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    RealEstateSearchParams params,
  ) async {
    return await repository.searchRealEstateRooms(params);
  }
}

class SearchRealEstateInvestment
    extends UseCase<SearchResults, RealEstateSearchParams> {
  final SearchRepository repository;

  SearchRealEstateInvestment(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    RealEstateSearchParams params,
  ) async {
    return await repository.searchRealEstateInvestment(params);
  }
}

// Vehicle Search Use Case
class SearchVehicles extends UseCase<SearchResults, VehicleSearchParams> {
  final SearchRepository repository;

  SearchVehicles(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    VehicleSearchParams params,
  ) async {
    return await repository.searchVehicles(params);
  }
}

// Service Search Use Case
class SearchServices extends UseCase<SearchResults, ServiceSearchParams> {
  final SearchRepository repository;

  SearchServices(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    ServiceSearchParams params,
  ) async {
    return await repository.searchServices(params);
  }
}

// Job Search Use Case
class SearchJobs extends UseCase<SearchResults, JobSearchParams> {
  final SearchRepository repository;

  SearchJobs(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(JobSearchParams params) async {
    return await repository.searchJobs(params);
  }
}

// Categories Use Cases
class GetCategories extends UseCase<List<Category>, NoParams> {
  final SearchRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

class GetSubcategories
    extends UseCase<List<Subcategory>, GetSubcategoriesParams> {
  final SearchRepository repository;

  GetSubcategories(this.repository);

  @override
  Future<Either<Failure, List<Subcategory>>> call(
    GetSubcategoriesParams params,
  ) async {
    return await repository.getSubcategories(categoryId: params.categoryId);
  }
}

class GetSubcategoriesParams {
  final int? categoryId;

  const GetSubcategoriesParams({this.categoryId});
}

// Featured Listings Use Cases
class GetFeaturedListings
    extends UseCase<SearchResults, GetFeaturedListingsParams> {
  final SearchRepository repository;

  GetFeaturedListings(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GetFeaturedListingsParams params,
  ) async {
    return await repository.getFeaturedListings(limit: params.limit);
  }
}

class GetFeaturedListingsParams {
  final int? limit;

  const GetFeaturedListingsParams({this.limit});
}

class GetRecentListings
    extends UseCase<SearchResults, GetRecentListingsParams> {
  final SearchRepository repository;

  GetRecentListings(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GetRecentListingsParams params,
  ) async {
    return await repository.getRecentListings(limit: params.limit);
  }
}

class GetRecentListingsParams {
  final int? limit;

  const GetRecentListingsParams({this.limit});
}

class GetPopularListings
    extends UseCase<SearchResults, GetPopularListingsParams> {
  final SearchRepository repository;

  GetPopularListings(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GetPopularListingsParams params,
  ) async {
    return await repository.getPopularListings(limit: params.limit);
  }
}

class GetPopularListingsParams {
  final int? limit;

  const GetPopularListingsParams({this.limit});
}

class GetNearbyListings
    extends UseCase<SearchResults, GetNearbyListingsParams> {
  final SearchRepository repository;

  GetNearbyListings(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GetNearbyListingsParams params,
  ) async {
    return await repository.getNearbyListings(
      lat: params.lat,
      lng: params.lng,
      radius: params.radius,
      limit: params.limit,
    );
  }
}

class GetNearbyListingsParams {
  final double lat;
  final double lng;
  final double? radius;
  final int? limit;

  const GetNearbyListingsParams({
    required this.lat,
    required this.lng,
    this.radius,
    this.limit,
  });
}

class GetSimilarListings
    extends UseCase<SearchResults, GetSimilarListingsParams> {
  final SearchRepository repository;

  GetSimilarListings(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    GetSimilarListingsParams params,
  ) async {
    return await repository.getSimilarListings(params.listingId);
  }
}

class GetSimilarListingsParams {
  final int listingId;

  const GetSimilarListingsParams({required this.listingId});
}

// Popular Searches Use Case
class GetPopularSearches extends UseCase<List<PopularSearch>, NoParams> {
  final SearchRepository repository;

  GetPopularSearches(this.repository);

  @override
  Future<Either<Failure, List<PopularSearch>>> call(NoParams params) async {
    return await repository.getPopularSearches();
  }
}

// Recent Searches Use Case
class GetRecentSearches extends UseCase<List<RecentSearch>, NoParams> {
  final SearchRepository repository;

  GetRecentSearches(this.repository);

  @override
  Future<Either<Failure, List<RecentSearch>>> call(NoParams params) async {
    return await repository.getRecentSearches();
  }
}
