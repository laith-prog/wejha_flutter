import 'package:wejha/features/home/domain/entities/home_data.dart';

class ListingModel extends ListingUi {
  const ListingModel({int? id, required String title, required String imageUrl, String? priceText})
      : super(id: id, title: title, imageUrl: imageUrl, priceText: priceText);

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    // Try common keys
    final id = _readInt(json['id']);
    final title = (json['title'] ?? json['name'] ?? json['model'] ?? 'بدون عنوان').toString();
    final image = (json['primary_image'] ?? json['image'] ?? json['main_image'] ?? json['thumbnail'] ?? json['cover'] ?? json['photo'] ?? '').toString();
    final price = json['price'] ?? json['price_formatted'] ?? json['salary'] ?? json['rent'] ?? null;
    final currency = json['currency'] ?? json['salary_currency'] ?? '';
    String? priceText;
    if (price != null) {
      priceText = currency != '' ? '$price $currency' : price.toString();
    }
    return ListingModel(id: id, title: title, imageUrl: image, priceText: priceText);
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}

class HomeBannerModel extends HomeBanner {
  const HomeBannerModel({required super.imageUrl, super.title, super.badge, super.ctaText});

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      imageUrl: (json['image'] ?? json['banner'] ?? json['cover'] ?? '').toString(),
      title: json['title']?.toString(),
      badge: json['badge']?.toString(),
      ctaText: json['cta_text']?.toString(),
    );
  }
}

class HomeCategoryModel extends HomeCategory {
  const HomeCategoryModel({int? id, required super.name, required super.displayName, super.iconUrl})
      : super(id: id);

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: ListingModel._readInt(json['id']),
      name: (json['name'] ?? '').toString(),
      displayName: (json['display_name'] ?? json['name'] ?? '').toString(),
      iconUrl: json['icon']?.toString(),
    );
  }
}

class HomeResponseModel {
  final List<HomeBannerModel> banners;
  final List<ListingModel> bestOffers;
  final List<ListingModel> latestListings;
  final List<HomeCategoryModel> categories;
  final List<ListingModel> topRated;

  HomeResponseModel({
    this.banners = const [],
    this.bestOffers = const [],
    this.latestListings = const [],
    this.categories = const [],
    this.topRated = const [],
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
      if (value is List) {
        return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
      }
      return <T>[];
    }

    Map<String, dynamic> data = json;
    // Some APIs wrap in { data: { ... } }
    if (json['data'] is Map<String, dynamic>) {
      data = json['data'];
    }

    // Get featured listings and use them for multiple sections if other sections are empty
    final featuredListings = parseList(data['featured_listings'] ?? data['best_offers'] ?? data['featured'] ?? data['offers'], (e) => ListingModel.fromJson(e));
    final latestListings = parseList(data['latest_listings'] ?? data['recent_listings'] ?? data['latest_ads'] ?? data['latest'], (e) => ListingModel.fromJson(e));
    final topRated = parseList(data['top_rated'] ?? data['most_rated'] ?? data['popular_listings'], (e) => ListingModel.fromJson(e));
    
    // Create fallback categories if none provided
    List<HomeCategoryModel> categories = parseList(data['categories'] ?? data['featured_categories'], (e) => HomeCategoryModel.fromJson(e));
    if (categories.isEmpty) {
      categories = [
        const HomeCategoryModel(id: 1, name: 'real_estate', displayName: 'عقار البيع'),
        const HomeCategoryModel(id: 2, name: 'vehicles', displayName: 'عقار الإيجار'),
        const HomeCategoryModel(id: 3, name: 'services', displayName: 'خدمات'),
      ];
    }

    return HomeResponseModel(
      banners: parseList(data['banners'] ?? data['ads'] ?? data['promos'], (e) => HomeBannerModel.fromJson(e)),
      bestOffers: featuredListings,
      latestListings: latestListings.isNotEmpty ? latestListings : featuredListings,
      categories: categories,
      topRated: topRated.isNotEmpty ? topRated : featuredListings,
    );
  }

  HomeData toEntity() => HomeData(
        banners: banners,
        bestOffers: bestOffers,
        latestListings: latestListings,
        categories: categories,
        topRated: topRated,
      );
} 