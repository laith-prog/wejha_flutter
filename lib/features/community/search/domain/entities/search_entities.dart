import 'package:equatable/equatable.dart';

// Base Search Parameters
class BaseSearchParams extends Equatable {
  final String? query;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;
  final double? radius;
  final int? limit;
  final int? page;
  final SortOption? sortBy;

  const BaseSearchParams({
    this.query,
    this.city,
    this.area,
    this.lat,
    this.lng,
    this.radius,
    this.limit,
    this.page,
    this.sortBy,
  });

  @override
  List<Object?> get props => [
    query,
    city,
    area,
    lat,
    lng,
    radius,
    limit,
    page,
    sortBy,
  ];
}

// Real Estate Search Parameters
class RealEstateSearchParams extends BaseSearchParams {
  final String? propertyType;
  final double? priceMin;
  final double? priceMax;
  final int? roomNumber;
  final int? bathrooms;
  final double? propertyAreaMin;
  final double? propertyAreaMax;
  final String? furnished;
  final bool? hasParking;
  final bool? hasGarden;
  final bool? hasPool;
  final bool? hasElevator;
  final List<String>? amenities;
  final int? yearBuiltMin;
  final int? yearBuiltMax;

  const RealEstateSearchParams({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    super.sortBy,
    this.propertyType,
    this.priceMin,
    this.priceMax,
    this.roomNumber,
    this.bathrooms,
    this.propertyAreaMin,
    this.propertyAreaMax,
    this.furnished,
    this.hasParking,
    this.hasGarden,
    this.hasPool,
    this.hasElevator,
    this.amenities,
    this.yearBuiltMin,
    this.yearBuiltMax,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    propertyType,
    priceMin,
    priceMax,
    roomNumber,
    bathrooms,
    propertyAreaMin,
    propertyAreaMax,
    furnished,
    hasParking,
    hasGarden,
    hasPool,
    hasElevator,
    amenities,
    yearBuiltMin,
    yearBuiltMax,
  ];
}

// Vehicle Search Parameters
class VehicleSearchParams extends BaseSearchParams {
  final String? make;
  final String? model;
  final int? yearMin;
  final int? yearMax;
  final double? priceMin;
  final double? priceMax;
  final int? mileageMax;
  final String? color;
  final String? transmission;
  final String? fuelType;
  final String? bodyType;
  final String? condition;
  final List<String>? vehicleFeatures;

  const VehicleSearchParams({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    super.sortBy,
    this.make,
    this.model,
    this.yearMin,
    this.yearMax,
    this.priceMin,
    this.priceMax,
    this.mileageMax,
    this.color,
    this.transmission,
    this.fuelType,
    this.bodyType,
    this.condition,
    this.vehicleFeatures,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    make,
    model,
    yearMin,
    yearMax,
    priceMin,
    priceMax,
    mileageMax,
    color,
    transmission,
    fuelType,
    bodyType,
    condition,
    vehicleFeatures,
  ];
}

// Service Search Parameters
class ServiceSearchParams extends BaseSearchParams {
  final int? subcategoryId;
  final double? priceMin;
  final double? priceMax;
  final String? priceType;
  final List<String>? availability;
  final int? experienceYearsMin;
  final bool? isMobile;

  const ServiceSearchParams({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    super.sortBy,
    this.subcategoryId,
    this.priceMin,
    this.priceMax,
    this.priceType,
    this.availability,
    this.experienceYearsMin,
    this.isMobile,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    subcategoryId,
    priceMin,
    priceMax,
    priceType,
    availability,
    experienceYearsMin,
    isMobile,
  ];
}

// Job Search Parameters
class JobSearchParams extends BaseSearchParams {
  final String? jobType;
  final String? attendanceType;
  final String? jobCategory;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryPeriod;
  final int? experienceYearsMin;
  final String? educationLevel;
  final String? companySize;
  final List<String>? benefits;

  const JobSearchParams({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    super.sortBy,
    this.jobType,
    this.attendanceType,
    this.jobCategory,
    this.salaryMin,
    this.salaryMax,
    this.salaryPeriod,
    this.experienceYearsMin,
    this.educationLevel,
    this.companySize,
    this.benefits,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    jobType,
    attendanceType,
    jobCategory,
    salaryMin,
    salaryMax,
    salaryPeriod,
    experienceYearsMin,
    educationLevel,
    companySize,
    benefits,
  ];
}

// Search Result Item Entity
class SearchResult extends Equatable {
  final int id;
  final String title;
  final String description;
  final double? price;
  final String? priceType;
  final String currency;
  final String phoneNumber;
  final String? purpose;
  final int subcategoryId;
  final double? lat;
  final double? lng;
  final String city;
  final String area;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? images;
  final Map<String, dynamic>? metadata;

  const SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    this.priceType,
    required this.currency,
    required this.phoneNumber,
    this.purpose,
    required this.subcategoryId,
    this.lat,
    this.lng,
    required this.city,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
    this.images,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    priceType,
    currency,
    phoneNumber,
    purpose,
    subcategoryId,
    lat,
    lng,
    city,
    area,
    createdAt,
    updatedAt,
    images,
    metadata,
  ];
}

// Search Results Response Entity
class SearchResults extends Equatable {
  final List<SearchResult> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const SearchResults({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;

  @override
  List<Object?> get props => [
    items,
    currentPage,
    lastPage,
    perPage,
    total,
    nextPageUrl,
    prevPageUrl,
  ];
}

// Category Entity
class Category extends Equatable {
  final int id;
  final String name;
  final String displayName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, displayName, createdAt, updatedAt];
}

// Subcategory Entity
class Subcategory extends Equatable {
  final int id;
  final int categoryId;
  final String name;
  final String displayName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    displayName,
    createdAt,
    updatedAt,
  ];
}

// Search Type Enum
enum SearchType {
  realEstateRentals,
  realEstateSales,
  realEstateRooms,
  realEstateInvestment,
  vehicles,
  services,
  jobs,
}

// Search Filter Configuration
class SearchFilterConfig extends Equatable {
  final SearchType searchType;
  final bool showPriceFilter;
  final bool showLocationFilter;
  final bool showDateFilter;
  final bool showCategoryFilter;
  final Map<String, List<String>> availableOptions;

  const SearchFilterConfig({
    required this.searchType,
    this.showPriceFilter = true,
    this.showLocationFilter = true,
    this.showDateFilter = false,
    this.showCategoryFilter = true,
    this.availableOptions = const {},
  });

  @override
  List<Object?> get props => [
    searchType,
    showPriceFilter,
    showLocationFilter,
    showDateFilter,
    showCategoryFilter,
    availableOptions,
  ];
}

// Popular Search Entity
class PopularSearch extends Equatable {
  final String query;
  final int count;
  final String? category;

  const PopularSearch({
    required this.query,
    required this.count,
    this.category,
  });

  @override
  List<Object?> get props => [query, count, category];
}

// Recent Search Entity
class RecentSearch extends Equatable {
  final String query;
  final DateTime timestamp;
  final String? category;

  const RecentSearch({
    required this.query,
    required this.timestamp,
    this.category,
  });

  @override
  List<Object?> get props => [query, timestamp, category];
}

// Sort Options Enum
enum SortOption {
  newest,
  oldest,
  priceHighToLow,
  priceLowToHigh,
  relevance,
  distance,
  last24Hours,
  last7Days,
}

// Sort Option Extension for Display Names
extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.newest:
        return 'من الأحدث للأقدم';
      case SortOption.oldest:
        return 'من الأقدم للأحدث';
      case SortOption.priceHighToLow:
        return 'السعر من الأعلى للأقل';
      case SortOption.priceLowToHigh:
        return 'السعر من الأقل للأعلى';
      case SortOption.relevance:
        return 'الأكثر صلة';
      case SortOption.distance:
        return 'الأقرب مسافة';
      case SortOption.last24Hours:
        return 'آخر 24 ساعة';
      case SortOption.last7Days:
        return 'آخر 7 أيام';
    }
  }

  String get apiValue {
    switch (this) {
      case SortOption.newest:
        return 'created_at_desc';
      case SortOption.oldest:
        return 'created_at_asc';
      case SortOption.priceHighToLow:
        return 'price_desc';
      case SortOption.priceLowToHigh:
        return 'price_asc';
      case SortOption.relevance:
        return 'relevance';
      case SortOption.distance:
        return 'distance';
      case SortOption.last24Hours:
        return 'last_24_hours';
      case SortOption.last7Days:
        return 'last_7_days';
    }
  }
}
