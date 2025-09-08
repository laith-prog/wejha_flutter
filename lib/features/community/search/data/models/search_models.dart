// Manual JSON conversion for search models

// Base Search Request
class BaseSearchRequest {
  final String? query;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;
  final double? radius;
  final int? limit;
  final int? page;

  const BaseSearchRequest({
    this.query,
    this.city,
    this.area,
    this.lat,
    this.lng,
    this.radius,
    this.limit,
    this.page,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (query != null) map['query'] = query;
    if (city != null) map['city'] = city;
    if (area != null) map['area'] = area;
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (radius != null) map['radius'] = radius;
    if (limit != null) map['limit'] = limit;
    if (page != null) map['page'] = page;
    return map;
  }
}

// Real Estate Search Request
class RealEstateSearchRequest extends BaseSearchRequest {
  final String? propertyType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final String? rooms;
  final int? bathrooms;
  final bool? isRoomRental;
  final bool? facilityUnderConstruction;
  final String? furnished;
  final bool? hasParking;
  final bool? hasGarden;
  final bool? hasPool;
  final bool? hasElevator;
  final List<String>? amenities;
  final int? minProgress;
  final int? maxProgress;
  final String? minCompletionDate;
  final String? maxCompletionDate;
  final String? paymentPlan;
  final String? offerType;
  final String? genderPreference;
  final bool? utilitiesIncluded;
  final bool? internetIncluded;

  const RealEstateSearchRequest({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    this.propertyType,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.rooms,
    this.bathrooms,
    this.isRoomRental,
    this.facilityUnderConstruction,
    this.furnished,
    this.hasParking,
    this.hasGarden,
    this.hasPool,
    this.hasElevator,
    this.amenities,
    this.minProgress,
    this.maxProgress,
    this.minCompletionDate,
    this.maxCompletionDate,
    this.paymentPlan,
    this.offerType,
    this.genderPreference,
    this.utilitiesIncluded,
    this.internetIncluded,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (propertyType != null) map['property_type'] = propertyType;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (minArea != null) map['min_area'] = minArea;
    if (maxArea != null) map['max_area'] = maxArea;
    if (rooms != null) map['rooms'] = rooms;
    if (bathrooms != null) map['bathrooms'] = bathrooms;
    if (isRoomRental != null) map['is_room_rental'] = isRoomRental;
    if (facilityUnderConstruction != null)
      map['facility_under_construction'] = facilityUnderConstruction;
    if (furnished != null) map['furnished'] = furnished;
    if (hasParking != null) map['has_parking'] = hasParking;
    if (hasGarden != null) map['has_garden'] = hasGarden;
    if (hasPool != null) map['has_pool'] = hasPool;
    if (hasElevator != null) map['has_elevator'] = hasElevator;
    if (amenities != null) map['amenities'] = amenities;
    if (minProgress != null) map['min_progress'] = minProgress;
    if (maxProgress != null) map['max_progress'] = maxProgress;
    if (minCompletionDate != null)
      map['min_completion_date'] = minCompletionDate;
    if (maxCompletionDate != null)
      map['max_completion_date'] = maxCompletionDate;
    if (paymentPlan != null) map['payment_plan'] = paymentPlan;
    if (offerType != null) map['offer_type'] = offerType;
    if (genderPreference != null) map['gender_preference'] = genderPreference;
    if (utilitiesIncluded != null)
      map['utilities_included'] = utilitiesIncluded;
    if (internetIncluded != null) map['internet_included'] = internetIncluded;
    return map;
  }
}

// Vehicle Search Request
class VehicleSearchRequest extends BaseSearchRequest {
  final String? vehicleType;
  final String? make;
  final String? model;
  final int? minYear;
  final int? maxYear;
  final double? minPrice;
  final double? maxPrice;
  final int? minMileage;
  final int? maxMileage;
  final String? transmission;
  final String? fuelType;
  final String? color;
  final String? bodyType;
  final String? condition;
  final List<String>? features;

  const VehicleSearchRequest({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    this.vehicleType,
    this.make,
    this.model,
    this.minYear,
    this.maxYear,
    this.minPrice,
    this.maxPrice,
    this.minMileage,
    this.maxMileage,
    this.transmission,
    this.fuelType,
    this.color,
    this.bodyType,
    this.condition,
    this.features,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (vehicleType != null) map['vehicle_type'] = vehicleType;
    if (make != null) map['make'] = make;
    if (model != null) map['model'] = model;
    if (minYear != null) map['min_year'] = minYear;
    if (maxYear != null) map['max_year'] = maxYear;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (minMileage != null) map['min_mileage'] = minMileage;
    if (maxMileage != null) map['max_mileage'] = maxMileage;
    if (transmission != null) map['transmission'] = transmission;
    if (fuelType != null) map['fuel_type'] = fuelType;
    if (color != null) map['color'] = color;
    if (bodyType != null) map['body_type'] = bodyType;
    if (condition != null) map['condition'] = condition;
    if (features != null) map['features'] = features;
    return map;
  }
}

// Service Search Request
class ServiceSearchRequest extends BaseSearchRequest {
  final String? serviceType;
  final int? subcategoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? priceType;
  final int? minExperience;
  final double? minRating;
  final bool? isMobile;
  final String? availableDay;
  final bool? isCertified;

  const ServiceSearchRequest({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    this.serviceType,
    this.subcategoryId,
    this.minPrice,
    this.maxPrice,
    this.priceType,
    this.minExperience,
    this.minRating,
    this.isMobile,
    this.availableDay,
    this.isCertified,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (serviceType != null) map['service_type'] = serviceType;
    if (subcategoryId != null) map['subcategory_id'] = subcategoryId;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (priceType != null) map['price_type'] = priceType;
    if (minExperience != null) map['min_experience'] = minExperience;
    if (minRating != null) map['min_rating'] = minRating;
    if (isMobile != null) map['is_mobile'] = isMobile;
    if (availableDay != null) map['available_day'] = availableDay;
    if (isCertified != null) map['is_certified'] = isCertified;
    return map;
  }
}

// Job Search Request
class JobSearchRequest extends BaseSearchRequest {
  final String? jobType;
  final int? subcategoryId;
  final double? minSalary;
  final double? maxSalary;
  final String? experienceLevel;
  final String? educationLevel;
  final String? isRemote;
  final String? attendanceType;
  final String? companySize;
  final String? industry;
  final List<String>? benefits;

  const JobSearchRequest({
    super.query,
    super.city,
    super.area,
    super.lat,
    super.lng,
    super.radius,
    super.limit,
    super.page,
    this.jobType,
    this.subcategoryId,
    this.minSalary,
    this.maxSalary,
    this.experienceLevel,
    this.educationLevel,
    this.isRemote,
    this.attendanceType,
    this.companySize,
    this.industry,
    this.benefits,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (jobType != null) map['job_type'] = jobType;
    if (subcategoryId != null) map['subcategory_id'] = subcategoryId;
    if (minSalary != null) map['min_salary'] = minSalary;
    if (maxSalary != null) map['max_salary'] = maxSalary;
    if (experienceLevel != null) map['experience_level'] = experienceLevel;
    if (educationLevel != null) map['education_level'] = educationLevel;
    if (isRemote != null) map['is_remote'] = isRemote;
    if (attendanceType != null) map['attendance_type'] = attendanceType;
    if (companySize != null) map['company_size'] = companySize;
    if (industry != null) map['industry'] = industry;
    if (benefits != null) map['benefits'] = benefits;
    return map;
  }
}

// Generic Search Response Item
class SearchResultItem {
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
  final String createdAt;
  final String updatedAt;
  final List<String>? images;
  final Map<String, dynamic>? metadata;

  const SearchResultItem({
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

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return SearchResultItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: toDouble(json['price']),
      priceType: json['price_type'],
      currency: json['currency'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      purpose: json['purpose'],
      subcategoryId: json['subcategory_id'] ?? 0,
      lat: toDouble(json['lat']),
      lng: toDouble(json['lng']),
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      metadata: json['metadata'],
    );
  }
}

// Search Response
class SearchResponse {
  final List<SearchResultItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const SearchResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    // API may return data as list or as an envelope { data: { listings: [], ... } }
    dynamic rawData = json['data'] ?? json;

    // If data is a map and contains 'listings', use it. Otherwise, if it's a list use it directly.
    List<dynamic> dataList;
    if (rawData is Map<String, dynamic>) {
      dataList =
          (rawData['listings'] as List?) ?? (rawData['data'] as List?) ?? [];
    } else if (rawData is List) {
      dataList = rawData;
    } else {
      dataList = [];
    }

    int currentPage =
        json['current_page'] ?? json['meta']?['current_page'] ?? 1;
    int lastPage = json['last_page'] ?? json['meta']?['last_page'] ?? 1;
    int perPage =
        json['per_page'] ?? json['meta']?['per_page'] ?? dataList.length;
    int total = json['total'] ?? json['meta']?['total'] ?? dataList.length;
    String? nextPageUrl = json['next_page_url'] ?? json['links']?['next'];
    String? prevPageUrl = json['prev_page_url'] ?? json['links']?['prev'];

    return SearchResponse(
      data:
          dataList
              .whereType<Map<String, dynamic>>()
              .map((item) => SearchResultItem.fromJson(item))
              .toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
      nextPageUrl: nextPageUrl,
      prevPageUrl: prevPageUrl,
    );
  }
}

// Category Model
class CategoryModel {
  final int id;
  final String name;
  final String displayName;
  final String? createdAt;
  final String? updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

// Subcategory Model
class SubcategoryModel {
  final int id;
  final int categoryId;
  final String name;
  final String displayName;
  final String? createdAt;
  final String? updatedAt;

  const SubcategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

// Popular Search Model
class PopularSearchModel {
  final String query;
  final int count;
  final String? category;

  const PopularSearchModel({
    required this.query,
    required this.count,
    this.category,
  });

  factory PopularSearchModel.fromJson(Map<String, dynamic> json) {
    return PopularSearchModel(
      query: json['query'] ?? '',
      count: json['count'] ?? 0,
      category: json['category'],
    );
  }
}

// Recent Search Model
class RecentSearchModel {
  final String query;
  final String timestamp;
  final String? category;

  const RecentSearchModel({
    required this.query,
    required this.timestamp,
    this.category,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      query: json['query'] ?? '',
      timestamp: json['timestamp'] ?? '',
      category: json['category'],
    );
  }
}
