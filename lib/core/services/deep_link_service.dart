import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';

/// A service for handling deep links in the application.
/// Uses app_links package which is the recommended replacement for uni_links.
class DeepLinkService {
  // Singleton instance
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  // Stream controller for deep links
  final StreamController<Uri> _deepLinkStreamController = StreamController<Uri>.broadcast();
  Stream<Uri> get deepLinkStream => _deepLinkStreamController.stream;

  // Flag to prevent multiple initializations
  bool _isInitialized = false;
  
  // AppLinks instance
  AppLinks? _appLinks;

  // Initialize deep linking
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Skip initialization in web mode
    if (kIsWeb) {
      debugPrint('Deep linking is not supported on web platform');
      return;
    }

    try {
      debugPrint('Initializing AppLinks for deep linking...');
      _appLinks = AppLinks();
      
      // Get initial link if the app was opened with a deep link
      final Uri? initialLink = await _appLinks?.getInitialAppLink();
      debugPrint('Initial deep link check: ${initialLink?.toString() ?? "none"}');
      
      if (initialLink != null) {
        debugPrint('Got initial deep link: $initialLink');
        _processDeepLink(initialLink);
      }
      
      // Listen for new links
      _appLinks?.uriLinkStream.listen((Uri uri) {
        debugPrint('Got deep link from stream: $uri');
        _processDeepLink(uri);
      }, onError: (error) {
        debugPrint('Deep link stream error: $error');
      });
      
      debugPrint('Deep link service initialized successfully');
    } on PlatformException catch (e) {
      debugPrint('Platform exception in deep linking: ${e.message}');
    } catch (e) {
      debugPrint('Error setting up deep links: $e');
    }
  }
  
  // Process incoming deep links
  void _processDeepLink(Uri uri) {
    try {
      debugPrint('Processing deep link: ${uri.toString()}');
      debugPrint('Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');
      debugPrint('Query parameters: ${uri.queryParameters}');
      
      // Add to stream for listeners
      _deepLinkStreamController.add(uri);
    } catch (e) {
      debugPrint('Error processing deep link: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _deepLinkStreamController.close();
  }
} 