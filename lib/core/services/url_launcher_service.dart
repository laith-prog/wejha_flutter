import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherService {
  // Singleton instance
  static final UrlLauncherService _instance = UrlLauncherService._internal();
  factory UrlLauncherService() => _instance;
  UrlLauncherService._internal();

  /// Launch a URL and handle Google OAuth URLs specially
  Future<bool> launchUrl(String urlString) async {
    debugPrint('Attempting to launch URL: $urlString');
    
    final Uri url = Uri.parse(urlString);
    
    // Check if this is a Google OAuth URL
    if (url.path.contains('/api/v1/auth/google') || url.path.contains('google/callback')) {
      debugPrint('Detected Google OAuth URL, using external browser');
      
      // For OAuth URLs, we need to use the external browser
      // This ensures proper cookie handling and session management
      return await _launchExternalBrowser(urlString);
    }
    
    // For regular URLs, we can use the default launch behavior
    return await _launchInApp(url);
  }
  
  /// Launch URL in external browser (most reliable for OAuth)
  Future<bool> _launchExternalBrowser(String url) async {
    try {
      debugPrint('Launching in external browser: $url');
      
      // Use canLaunchUrlString first to check if the URL can be handled
      if (await canLaunchUrlString(url)) {
        final bool launched = await launchUrlString(
          url,
          mode: LaunchMode.externalApplication, // Force external browser
        );
        
        debugPrint('URL launch result: $launched');
        return launched;
      } else {
        debugPrint('Cannot launch URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }
  
  /// Launch URL in the app
  Future<bool> _launchInApp(Uri url) async {
    try {
      debugPrint('Launching in app: $url');
      
      if (await url_launcher.canLaunchUrl(url)) {
        final bool launched = await url_launcher.launchUrl(
          url,
          mode: url_launcher.LaunchMode.inAppWebView,
          webViewConfiguration: const url_launcher.WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        
        debugPrint('URL launch result: $launched');
        return launched;
      } else {
        debugPrint('Cannot launch URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }
} 