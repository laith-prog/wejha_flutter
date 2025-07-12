import '../constants/api_constants.dart';

class UrlHelper {
  /// Formats an image URL by adding the base URL if it doesn't already have one
  static String formatImageUrl(String? imageUrl) {
    if (imageUrl == null) return '';
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    return '${ApiConstants.baseUrl}/$imageUrl';
  }
} 