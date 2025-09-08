import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/search_entities.dart';

abstract class SearchRepository {
  // General keyword search (no filters)
  Future<Either<Failure, SearchResults>> generalSearch({
    required String keyword,
    int? page,
    int? limit,
  });

  // Real Estate Search
  Future<Either<Failure, SearchResults>> searchRealEstateForRent(
    RealEstateSearchParams params,
  );

  Future<Either<Failure, SearchResults>> searchRealEstateForSale(
    RealEstateSearchParams params,
  );

  Future<Either<Failure, SearchResults>> searchRealEstateRooms(
    RealEstateSearchParams params,
  );

  Future<Either<Failure, SearchResults>> searchRealEstateInvestment(
    RealEstateSearchParams params,
  );

  // Vehicle Search
  Future<Either<Failure, SearchResults>> searchVehicles(
    VehicleSearchParams params,
  );

  // Service Search
  Future<Either<Failure, SearchResults>> searchServices(
    ServiceSearchParams params,
  );

  // Job Search
  Future<Either<Failure, SearchResults>> searchJobs(JobSearchParams params);

  // Categories and Subcategories
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Subcategory>>> getSubcategories({
    int? categoryId,
  });

  // Featured, Recent, Popular, Nearby listings
  Future<Either<Failure, SearchResults>> getFeaturedListings({int? limit});

  Future<Either<Failure, SearchResults>> getRecentListings({int? limit});

  Future<Either<Failure, SearchResults>> getPopularListings({int? limit});

  Future<Either<Failure, SearchResults>> getNearbyListings({
    required double lat,
    required double lng,
    double? radius,
    int? limit,
  });

  // Similar listings
  Future<Either<Failure, SearchResults>> getSimilarListings(int listingId);

  // Popular and Recent searches
  Future<Either<Failure, List<PopularSearch>>> getPopularSearches();

  Future<Either<Failure, List<RecentSearch>>> getRecentSearches();
}
