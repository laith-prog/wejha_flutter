import 'package:equatable/equatable.dart';
import '../../domain/entities/search_entities.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResults results;
  final SearchType searchType;
  final Map<String, dynamic> currentFilters;
  final bool hasMore;

  const SearchLoaded({
    required this.results,
    required this.searchType,
    this.currentFilters = const {},
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [results, searchType, currentFilters, hasMore];

  SearchLoaded copyWith({
    SearchResults? results,
    SearchType? searchType,
    Map<String, dynamic>? currentFilters,
    bool? hasMore,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      searchType: searchType ?? this.searchType,
      currentFilters: currentFilters ?? this.currentFilters,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SearchLoadingMore extends SearchState {
  final SearchResults currentResults;
  final SearchType searchType;
  final Map<String, dynamic> currentFilters;

  const SearchLoadingMore({
    required this.currentResults,
    required this.searchType,
    this.currentFilters = const {},
  });

  @override
  List<Object?> get props => [currentResults, searchType, currentFilters];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {
  final SearchType searchType;
  final Map<String, dynamic> currentFilters;

  const SearchEmpty({
    required this.searchType,
    this.currentFilters = const {},
  });

  @override
  List<Object?> get props => [searchType, currentFilters];
}

// Categories States
class CategoriesLoading extends SearchState {}

class CategoriesLoaded extends SearchState {
  final List<Category> categories;
  final List<Subcategory> subcategories;

  const CategoriesLoaded({
    required this.categories,
    this.subcategories = const [],
  });

  @override
  List<Object?> get props => [categories, subcategories];

  CategoriesLoaded copyWith({
    List<Category>? categories,
    List<Subcategory>? subcategories,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

class CategoriesError extends SearchState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Filter States
class FiltersChanged extends SearchState {
  final Map<String, dynamic> filters;
  final SearchType searchType;

  const FiltersChanged({
    required this.filters,
    required this.searchType,
  });

  @override
  List<Object?> get props => [filters, searchType];
}

// Featured/Recent/Popular/Nearby States
class FeaturedListingsLoaded extends SearchState {
  final SearchResults results;

  const FeaturedListingsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class RecentListingsLoaded extends SearchState {
  final SearchResults results;

  const RecentListingsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class PopularListingsLoaded extends SearchState {
  final SearchResults results;

  const PopularListingsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class NearbyListingsLoaded extends SearchState {
  final SearchResults results;

  const NearbyListingsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class SimilarListingsLoaded extends SearchState {
  final SearchResults results;

  const SimilarListingsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

// Popular Searches States
class PopularSearchesLoading extends SearchState {}

class PopularSearchesLoaded extends SearchState {
  final List<PopularSearch> searches;

  const PopularSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}

class PopularSearchesError extends SearchState {
  final String message;

  const PopularSearchesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Recent Searches States
class RecentSearchesLoading extends SearchState {}

class RecentSearchesLoaded extends SearchState {
  final List<RecentSearch> searches;

  const RecentSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}

class RecentSearchesError extends SearchState {
  final String message;

  const RecentSearchesError(this.message);

  @override
  List<Object?> get props => [message];
}

