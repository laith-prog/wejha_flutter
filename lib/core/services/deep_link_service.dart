import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  final StreamController<Uri> _deepLinkStreamController = StreamController<Uri>.broadcast();
  Stream<Uri> get deepLinkStream => _deepLinkStreamController.stream;
  
  bool _initialized = false;
  
  // Manual handling for deep links
  void handleDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      debugPrint('Processing deep link: $uri');
      _deepLinkStreamController.add(uri);
    } catch (e) {
      debugPrint('Error processing deep link: $e');
    }
  }
  
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    debugPrint('Deep link service initialized');
  }
  
  void dispose() {
    _deepLinkStreamController.close();
  }
  
  // Helper method to extract code from callback URL
  String? extractAuthCodeFromUri(Uri uri) {
    if (uri.queryParameters.containsKey('code')) {
      return uri.queryParameters['code'];
    }
    return null;
  }
} 