import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/usecases/search_use_cases.dart' as use_cases;
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final use_cases.GeneralSearch generalSearch;
  final use_cases.SearchRealEstateForRent searchRealEstateForRent;
  final use_cases.SearchRealEstateForSale searchRealEstateForSale;
  final use_cases.SearchRealEstateRooms searchRealEstateRooms;
  final use_cases.SearchRealEstateInvestment searchRealEstateInvestment;
  final use_cases.SearchVehicles searchVehicles;
  final use_cases.SearchServices searchServices;
  final use_cases.SearchJobs searchJobs;
  final use_cases.GetCategories getCategories;
  final use_cases.GetSubcategories getSubcategories;
  final use_cases.GetFeaturedListings getFeaturedListings;
  final use_cases.GetRecentListings getRecentListings;
  final use_cases.GetPopularListings getPopularListings;
  final use_cases.GetNearbyListings getNearbyListings;
  final use_cases.GetSimilarListings getSimilarListings;
  final use_cases.GetPopularSearches getPopularSearches;
  final use_cases.GetRecentSearches getRecentSearches;

  SearchType _currentSearchType = SearchType.realEstateRentals;
  Map<String, dynamic> _currentFilters = {};
  SearchResults? _currentResults;

  // Caching flags/data to avoid duplicate network calls
  bool _popularSearchesLoaded = false;
  bool _recentSearchesLoaded = false;
  bool _popularSearchesInFlight = false;
  bool _recentSearchesInFlight = false;
  List<PopularSearch>? _popularSearchesCache;
  List<RecentSearch>? _recentSearchesCache;

  SearchBloc({
    required this.generalSearch,
    required this.searchRealEstateForRent,
    required this.searchRealEstateForSale,
    required this.searchRealEstateRooms,
    required this.searchRealEstateInvestment,
    required this.searchVehicles,
    required this.searchServices,
    required this.searchJobs,
    required this.getCategories,
    required this.getSubcategories,
    required this.getFeaturedListings,
    required this.getRecentListings,
    required this.getPopularListings,
    required this.getNearbyListings,
    required this.getSimilarListings,
    required this.getPopularSearches,
    required this.getRecentSearches,
  }) : super(SearchInitial()) {
    on<SearchTypeChanged>(_onSearchTypeChanged);
    on<SearchFilterChanged>(_onSearchFilterChanged);
    on<ClearFilters>(_onClearFilters);
    on<GeneralSearch>(_onGeneralSearch);
    on<SearchRealEstateForRent>(_onSearchRealEstateForRent);
    on<SearchRealEstateForSale>(_onSearchRealEstateForSale);
    on<SearchRealEstateRooms>(_onSearchRealEstateRooms);
    on<SearchRealEstateInvestment>(_onSearchRealEstateInvestment);
    on<SearchVehicles>(_onSearchVehicles);
    on<SearchServices>(_onSearchServices);
    on<SearchJobs>(_onSearchJobs);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<LoadCategories>(_onLoadCategories);
    on<LoadSubcategories>(_onLoadSubcategories);
    on<LoadFeaturedListings>(_onLoadFeaturedListings);
    on<LoadRecentListings>(_onLoadRecentListings);
    on<LoadPopularListings>(_onLoadPopularListings);
    on<LoadNearbyListings>(_onLoadNearbyListings);
    on<LoadSimilarListings>(_onLoadSimilarListings);
    on<ResetSearch>(_onResetSearch);
    on<LoadPopularSearches>(_onLoadPopularSearches);
    on<LoadRecentSearches>(_onLoadRecentSearches);
  }

  void _onSearchTypeChanged(
    SearchTypeChanged event,
    Emitter<SearchState> emit,
  ) {
    _currentSearchType = event.searchType;
    _currentFilters.clear();
    emit(
      FiltersChanged(filters: _currentFilters, searchType: _currentSearchType),
    );
  }

  void _onSearchFilterChanged(
    SearchFilterChanged event,
    Emitter<SearchState> emit,
  ) {
    _currentFilters = Map.from(event.filters);
    emit(
      FiltersChanged(filters: _currentFilters, searchType: _currentSearchType),
    );
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) {
    _currentFilters.clear();
    emit(
      FiltersChanged(filters: _currentFilters, searchType: _currentSearchType),
    );
  }

  void _onGeneralSearch(GeneralSearch event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final result = await generalSearch(
      use_cases.GeneralSearchParams(
        keyword: event.keyword,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      // For general search, clear any filters and show results regardless of empty/non-empty
      _currentFilters.clear();
      emit(
        SearchLoaded(
          results: searchResults,
          searchType: _currentSearchType,
          currentFilters: _currentFilters,
          hasMore: searchResults.hasNextPage,
        ),
      );
    });
  }

  void _onSearchRealEstateForRent(
    SearchRealEstateForRent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchRealEstateForRent(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.realEstateRentals,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.realEstateRentals,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchRealEstateForSale(
    SearchRealEstateForSale event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchRealEstateForSale(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.realEstateSales,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.realEstateSales,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchRealEstateRooms(
    SearchRealEstateRooms event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchRealEstateRooms(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.realEstateRooms,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.realEstateRooms,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchRealEstateInvestment(
    SearchRealEstateInvestment event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchRealEstateInvestment(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.realEstateInvestment,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.realEstateInvestment,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchVehicles(
    SearchVehicles event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchVehicles(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.vehicles,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.vehicles,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchServices(
    SearchServices event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchServices(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.services,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.services,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onSearchJobs(SearchJobs event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final result = await searchJobs(event.params);

    result.fold((failure) => emit(SearchError(failure.message)), (
      searchResults,
    ) {
      _currentResults = searchResults;
      if (searchResults.items.isEmpty) {
        emit(
          SearchEmpty(
            searchType: SearchType.jobs,
            currentFilters: _currentFilters,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            results: searchResults,
            searchType: SearchType.jobs,
            currentFilters: _currentFilters,
            hasMore: searchResults.hasNextPage,
          ),
        );
      }
    });
  }

  void _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    if (_currentResults == null || !_currentResults!.hasNextPage) return;

    final currentState = state;
    if (currentState is! SearchLoaded) return;

    emit(
      SearchLoadingMore(
        currentResults: _currentResults!,
        searchType: _currentSearchType,
        currentFilters: _currentFilters,
      ),
    );

    // TODO: Implement pagination logic based on search type
    // This would require storing the current search parameters
    // final nextPage = _currentResults!.currentPage + 1;
  }

  void _onLoadCategories(
    LoadCategories event,
    Emitter<SearchState> emit,
  ) async {
    emit(CategoriesLoading());
    final result = await getCategories(NoParams());

    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  void _onLoadSubcategories(
    LoadSubcategories event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      final result = await getSubcategories(
        use_cases.GetSubcategoriesParams(categoryId: event.categoryId),
      );

      result.fold(
        (failure) => emit(CategoriesError(failure.message)),
        (subcategories) =>
            emit(currentState.copyWith(subcategories: subcategories)),
      );
    }
  }

  void _onLoadFeaturedListings(
    LoadFeaturedListings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await getFeaturedListings(
      use_cases.GetFeaturedListingsParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchResults) => emit(FeaturedListingsLoaded(searchResults)),
    );
  }

  void _onLoadRecentListings(
    LoadRecentListings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await getRecentListings(
      use_cases.GetRecentListingsParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchResults) => emit(RecentListingsLoaded(searchResults)),
    );
  }

  void _onLoadPopularListings(
    LoadPopularListings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await getPopularListings(
      use_cases.GetPopularListingsParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchResults) => emit(PopularListingsLoaded(searchResults)),
    );
  }

  void _onLoadNearbyListings(
    LoadNearbyListings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await getNearbyListings(
      use_cases.GetNearbyListingsParams(
        lat: event.lat,
        lng: event.lng,
        radius: event.radius,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchResults) => emit(NearbyListingsLoaded(searchResults)),
    );
  }

  void _onLoadSimilarListings(
    LoadSimilarListings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await getSimilarListings(
      use_cases.GetSimilarListingsParams(listingId: event.listingId),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (searchResults) => emit(SimilarListingsLoaded(searchResults)),
    );
  }

  void _onResetSearch(ResetSearch event, Emitter<SearchState> emit) {
    _currentSearchType = SearchType.realEstateRentals;
    _currentFilters.clear();
    _currentResults = null;
    emit(SearchInitial());
  }

  void _onLoadPopularSearches(
    LoadPopularSearches event,
    Emitter<SearchState> emit,
  ) async {
    // If already loaded, emit cached data and skip network call
    if (_popularSearchesLoaded && _popularSearchesCache != null) {
      emit(PopularSearchesLoaded(_popularSearchesCache!));
      return;
    }
    // If a request is in flight, do nothing (prevents bursts)
    if (_popularSearchesInFlight) return;

    _popularSearchesInFlight = true;
    emit(PopularSearchesLoading());
    final result = await getPopularSearches(NoParams());

    result.fold(
      (failure) {
        _popularSearchesInFlight = false;
        emit(PopularSearchesError(failure.message));
      },
      (searches) {
        _popularSearchesInFlight = false;
        _popularSearchesLoaded = true;
        _popularSearchesCache = searches;
        emit(PopularSearchesLoaded(searches));
      },
    );
  }

  void _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    // If already loaded, emit cached data and skip network call
    if (_recentSearchesLoaded && _recentSearchesCache != null) {
      emit(RecentSearchesLoaded(_recentSearchesCache!));
      return;
    }
    // If a request is in flight, do nothing (prevents bursts)
    if (_recentSearchesInFlight) return;

    _recentSearchesInFlight = true;
    emit(RecentSearchesLoading());
    final result = await getRecentSearches(NoParams());

    result.fold(
      (failure) {
        _recentSearchesInFlight = false;
        emit(RecentSearchesError(failure.message));
      },
      (searches) {
        _recentSearchesInFlight = false;
        _recentSearchesLoaded = true;
        _recentSearchesCache = searches;
        emit(RecentSearchesLoaded(searches));
      },
    );
  }
}
