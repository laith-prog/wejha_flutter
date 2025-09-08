import 'package:equatable/equatable.dart';

class ListingUi extends Equatable {
  final int? id;
  final String title;
  final String imageUrl;
  final String? priceText;

  const ListingUi({this.id, required this.title, required this.imageUrl, this.priceText});

  @override
  List<Object?> get props => [id, title, imageUrl, priceText];
}

class HomeBanner extends Equatable {
  final String imageUrl;
  final String? title;
  final String? badge;
  final String? ctaText;

  const HomeBanner({required this.imageUrl, this.title, this.badge, this.ctaText});

  @override
  List<Object?> get props => [imageUrl, title, badge, ctaText];
}

class HomeCategory extends Equatable {
  final int? id;
  final String name;
  final String displayName;
  final String? iconUrl;

  const HomeCategory({this.id, required this.name, required this.displayName, this.iconUrl});

  @override
  List<Object?> get props => [id, name, displayName, iconUrl];
}

class HomeData extends Equatable {
  final List<HomeBanner> banners;
  final List<ListingUi> bestOffers;
  final List<ListingUi> latestListings;
  final List<HomeCategory> categories;
  final List<ListingUi> topRated;

  const HomeData({
    this.banners = const [],
    this.bestOffers = const [],
    this.latestListings = const [],
    this.categories = const [],
    this.topRated = const [],
  });

  @override
  List<Object?> get props => [banners, bestOffers, latestListings, categories, topRated];
} 