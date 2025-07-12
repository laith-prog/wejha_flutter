import 'package:flutter/material.dart';
import '../config/environment.dart';

class EnvironmentChecker {
  static void printEnvironmentInfo() {
    final env = EnvironmentConfig.environment;
    final baseUrl = EnvironmentConfig.baseUrl;
    
    debugPrint('==================================');
    debugPrint('🌐 ENVIRONMENT: ${env.name.toUpperCase()}');
    debugPrint('🔗 API URL: $baseUrl');
    debugPrint('==================================');
  }
} 