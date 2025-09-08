import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/components/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/search_entities.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_filters_widget.dart';
import '../widgets/search_results_widget.dart';
import '../widgets/popular_searches_widget.dart';
import '../widgets/recent_searches_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  SearchType _currentSearchType = SearchType.realEstateRentals;
  Map<String, dynamic> _currentFilters = {};
  SortOption _currentSortOption = SortOption.newest;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load categories and initial search meta on page init
    context.read<SearchBloc>().add(LoadCategories());
    context.read<SearchBloc>().add(LoadPopularSearches());
    context.read<SearchBloc>().add(LoadRecentSearches());
    // Do not run any search on first open; wait for user to click the search icon
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more results when near bottom
      context.read<SearchBloc>().add(LoadMoreResults());
    }
  }

  void _onSortChanged(SortOption sortOption) {
    setState(() {
      _currentSortOption = sortOption;
    });
    // Perform search with new sort option
    _performSearch();
  }

  void _performSearch() {
    final query = _searchController.text.trim();

    // Check if filters have meaningful values
    final hasFilters = _currentFilters.entries.any((entry) {
      final value = entry.value;
      if (value == null) return false;
      if (value is String && value.isEmpty) return false;
      if (value is List && value.isEmpty) return false;
      if (value is Map && value.isEmpty) return false;
      if (value is bool) {
        return value; // For boolean filters, true means filter is applied
      }
      if (value is num) {
        return value > 0; // For numeric filters, positive values are meaningful
      }
      return true; // Any other non-null value is considered meaningful
    });

    // Debug: Print current search state (remove in production)
    // print('=== SEARCH DEBUG ===');
    // print('Query: "$query"');
    // print('Search Type: $_currentSearchType');
    // print('Has Filters: $hasFilters');
    // print('Current Filters: $_currentFilters');
    // print('==================');

    // If only keyword and no filters → general search
    if (query.isNotEmpty && !hasFilters) {
      context.read<SearchBloc>().add(
        GeneralSearch(keyword: query, page: 1, limit: 20),
      );
      return;
    }

    // If no keyword and no filters → do nothing (stay on initial view)
    if (query.isEmpty && !hasFilters) {
      return;
    }

    switch (_currentSearchType) {
      case SearchType.realEstateRentals:
        final params = RealEstateSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          roomNumber: _currentFilters['roomNumber'],
          bathrooms: _currentFilters['bathrooms'],
          propertyType: _currentFilters['propertyType'],
          furnished: _currentFilters['furnished'],
          hasParking: _currentFilters['hasParking'],
          hasGarden: _currentFilters['hasGarden'],
          hasPool: _currentFilters['hasPool'],
          hasElevator: _currentFilters['hasElevator'],
          amenities: _currentFilters['amenities'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchRealEstateForRent(params));
        break;

      case SearchType.realEstateSales:
        final params = RealEstateSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          roomNumber: _currentFilters['roomNumber'],
          bathrooms: _currentFilters['bathrooms'],
          propertyType: _currentFilters['propertyType'],
          furnished: _currentFilters['furnished'],
          hasParking: _currentFilters['hasParking'],
          hasGarden: _currentFilters['hasGarden'],
          hasPool: _currentFilters['hasPool'],
          hasElevator: _currentFilters['hasElevator'],
          amenities: _currentFilters['amenities'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchRealEstateForSale(params));
        break;

      case SearchType.realEstateRooms:
        final params = RealEstateSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          roomNumber: _currentFilters['roomNumber'],
          bathrooms: _currentFilters['bathrooms'],
          furnished: _currentFilters['furnished'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchRealEstateRooms(params));
        break;

      case SearchType.realEstateInvestment:
        final params = RealEstateSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          propertyType: _currentFilters['propertyType'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchRealEstateInvestment(params));
        break;

      case SearchType.vehicles:
        final params = VehicleSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          make: _currentFilters['make'],
          model: _currentFilters['model'],
          yearMin: _currentFilters['yearMin'],
          yearMax: _currentFilters['yearMax'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          mileageMax: _currentFilters['mileageMax'],
          color: _currentFilters['color'],
          transmission: _currentFilters['transmission'],
          fuelType: _currentFilters['fuelType'],
          bodyType: _currentFilters['bodyType'],
          condition: _currentFilters['condition'],
          vehicleFeatures: _currentFilters['vehicleFeatures'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchVehicles(params));
        break;

      case SearchType.services:
        final params = ServiceSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          subcategoryId: _currentFilters['subcategoryId'],
          priceMin: _currentFilters['priceMin'],
          priceMax: _currentFilters['priceMax'],
          priceType: _currentFilters['priceType'],
          availability: _currentFilters['availability'],
          experienceYearsMin: _currentFilters['experienceYearsMin'],
          isMobile: _currentFilters['isMobile'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchServices(params));
        break;

      case SearchType.jobs:
        final params = JobSearchParams(
          query: query.isNotEmpty ? query : null,
          city: _currentFilters['city'],
          area: _currentFilters['area'],
          jobType: _currentFilters['jobType'],
          attendanceType: _currentFilters['attendanceType'],
          jobCategory: _currentFilters['jobCategory'],
          salaryMin: _currentFilters['salaryMin'],
          salaryMax: _currentFilters['salaryMax'],
          salaryPeriod: _currentFilters['salaryPeriod'],
          experienceYearsMin: _currentFilters['experienceYearsMin'],
          educationLevel: _currentFilters['educationLevel'],
          companySize: _currentFilters['companySize'],
          benefits: _currentFilters['benefits'],
          sortBy: _currentSortOption,
          limit: 20,
          page: 1,
        );
        context.read<SearchBloc>().add(SearchJobs(params));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Search Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // Search row: filter + input + search
                  Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      // Filter button (left)
                      SizedBox(
                        height: 48.h,
                        width: 48.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _showFiltersBottomSheet,
                          child: const Icon(
                            Icons.filter_list,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Search input (right) with search icon inside
                      Expanded(
                        child: CustomTextField(
                          controller: _searchController,
                          hintText: 'ابحث عن عقار',
                          // Place tappable search icon inside the text field (suffix)
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              final query = _searchController.text.trim();
                              if (query.isEmpty) return;
                              context.read<SearchBloc>().add(
                                GeneralSearch(
                                  keyword: query,
                                  page: 1,
                                  limit: 20,
                                ),
                              );
                            },
                          ),
                          onSubmitted: (_) {
                            final query = _searchController.text.trim();
                            if (query.isEmpty) return;
                            context.read<SearchBloc>().add(
                              GeneralSearch(keyword: query, page: 1, limit: 20),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                buildWhen:
                    (previous, current) =>
                        current is SearchInitial ||
                        current is SearchLoading ||
                        current is SearchLoaded ||
                        current is SearchLoadingMore ||
                        current is SearchEmpty ||
                        current is SearchError ||
                        current is FiltersChanged,
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildInitialView();
                  } else if (state is SearchLoading) {
                    return const Center(child: LoadingIndicator());
                  } else if (state is SearchLoaded) {
                    return SearchResultsWidget(
                      results: state.results,
                      searchType: state.searchType,
                      scrollController: _scrollController,
                      currentSortOption: _currentSortOption,
                      onSortChanged: _onSortChanged,
                    );
                  } else if (state is SearchLoadingMore) {
                    return SearchResultsWidget(
                      results: state.currentResults,
                      searchType: state.searchType,
                      scrollController: _scrollController,
                      isLoadingMore: true,
                      currentSortOption: _currentSortOption,
                      onSortChanged: _onSortChanged,
                    );
                  } else if (state is SearchEmpty) {
                    return _buildEmptyView();
                  } else if (state is SearchError) {
                    return _buildErrorView(state.message);
                  } else if (state is FiltersChanged) {
                    _currentFilters = state.filters;
                    return _buildInitialView();
                  }
                  return _buildInitialView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Browse Categories title (styled like the target)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                  SizedBox(width: 4.w),
                  Text(
                    'تصفح الفئات',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.divider, height: 1.h),
            SizedBox(height: 12.h),

            // Recent Searches title
            Text(
              'اخر عمليات البحث',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),

            // Recent searches list (clicking item triggers search)
            SizedBox(
              height: 220.h,
              child: RecentSearchesWidget(
                onSearchSelected: (query) {
                  _searchController.text = query;
                  _performSearch();
                },
              ),
            ),

            SizedBox(height: 24.h),

            // Search hint at bottom
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    size: 48.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'ابدأ البحث للعثور على النتائج',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'جرب تغيير معايير البحث أو المرشحات',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _performSearch,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet() {
    // Get the SearchBloc before building the bottom sheet
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (bottomSheetContext) => BlocProvider<SearchBloc>.value(
            value: searchBloc,
            child: StatefulBuilder(
              builder:
                  (builderContext, setModalState) => SearchFiltersWidget(
                    searchType: _currentSearchType,
                    currentFilters: _currentFilters,
                    onFiltersChanged: (filters) {
                      setState(() {
                        _currentFilters = filters;
                      });
                      searchBloc.add(SearchFilterChanged(filters));
                      // Automatically perform search when filters are applied
                      _performSearch();
                    },
                    onSearchTypeChanged: (type) {
                      setState(() {
                        _currentSearchType = type;
                        _currentFilters.clear();
                      });
                      searchBloc.add(SearchTypeChanged(type));
                      setModalState(() {}); // Refresh the bottom sheet
                    },
                  ),
            ),
          ),
    );
  }
}
