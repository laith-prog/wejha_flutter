import 'package:equatable/equatable.dart';
import '../../domain/entities/search_entities.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

// Search Type Selection
class SearchTypeChanged extends SearchEvent {
  final SearchType searchType;

  const SearchTypeChanged(this.searchType);

  @override
  List<Object?> get props => [searchType];
}

// Filter Events
class SearchFilterChanged extends SearchEvent {
  final Map<String, dynamic> filters;

  const SearchFilterChanged(this.filters);

  @override
  List<Object?> get props => [filters];
}

class ClearFilters extends SearchEvent {}

// General keyword search (no filters)
class GeneralSearch extends SearchEvent {
  final String keyword;
  final int? page;
  final int? limit;

  const GeneralSearch({required this.keyword, this.page, this.limit});

  @override
  List<Object?> get props => [keyword, page, limit];
}

// Search Execution Events
class SearchRealEstateForRent extends SearchEvent {
  final RealEstateSearchParams params;

  const SearchRealEstateForRent(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchRealEstateForSale extends SearchEvent {
  final RealEstateSearchParams params;

  const SearchRealEstateForSale(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchRealEstateRooms extends SearchEvent {
  final RealEstateSearchParams params;

  const SearchRealEstateRooms(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchRealEstateInvestment extends SearchEvent {
  final RealEstateSearchParams params;

  const SearchRealEstateInvestment(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchVehicles extends SearchEvent {
  final VehicleSearchParams params;

  const SearchVehicles(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchServices extends SearchEvent {
  final ServiceSearchParams params;

  const SearchServices(this.params);

  @override
  List<Object?> get props => [params];
}

class SearchJobs extends SearchEvent {
  final JobSearchParams params;

  const SearchJobs(this.params);

  @override
  List<Object?> get props => [params];
}

// Load More Results (Pagination)
class LoadMoreResults extends SearchEvent {}

// Featured/Recent/Popular/Nearby Events
class LoadFeaturedListings extends SearchEvent {
  final int? limit;

  const LoadFeaturedListings({this.limit});

  @override
  List<Object?> get props => [limit];
}

class LoadRecentListings extends SearchEvent {
  final int? limit;

  const LoadRecentListings({this.limit});

  @override
  List<Object?> get props => [limit];
}

class LoadPopularListings extends SearchEvent {
  final int? limit;

  const LoadPopularListings({this.limit});

  @override
  List<Object?> get props => [limit];
}

class LoadNearbyListings extends SearchEvent {
  final double lat;
  final double lng;
  final double? radius;
  final int? limit;

  const LoadNearbyListings({
    required this.lat,
    required this.lng,
    this.radius,
    this.limit,
  });

  @override
  List<Object?> get props => [lat, lng, radius, limit];
}

class LoadSimilarListings extends SearchEvent {
  final int listingId;

  const LoadSimilarListings(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

// Categories Events
class LoadCategories extends SearchEvent {}

class LoadSubcategories extends SearchEvent {
  final int? categoryId;

  const LoadSubcategories({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

// Reset State
class ResetSearch extends SearchEvent {}

// Popular and Recent Searches
class LoadPopularSearches extends SearchEvent {}

class LoadRecentSearches extends SearchEvent {}
