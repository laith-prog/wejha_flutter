import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlLauncherService {
  // Singleton instance
  static final UrlLauncherService _instance = UrlLauncherService._internal();
  factory UrlLauncherService() => _instance;
  UrlLauncherService._internal();

  /// Launch a URL using WebView
  Future<bool> launchUrl(String urlString) async {
    debugPrint('Attempting to launch URL in WebView: $urlString');
    
    try {
      // Return true to indicate successful handling
      // The actual navigation will happen in the WebViewPage
      return true;
    } catch (e) {
      debugPrint('Error preparing WebView URL: $e');
      return false;
    }
  }
  
  /// Navigate to WebView page
  void navigateToWebView(BuildContext context, String url, {String title = 'Web Page'}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url, title: title),
      ),
    );
  }
}

/// WebView page to display web content
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    Key? key,
    required this.url,
    this.title = 'Web Page',
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
} 