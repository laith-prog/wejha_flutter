import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    try {
      final hasConnection = await connectionChecker.hasConnection;
      debugPrint('Network connection check: $hasConnection');
      return hasConnection;
    } catch (e) {
      debugPrint('Error checking network connection: $e');
      // Return true to allow the request to proceed even if the connection check fails
      // This prevents the connection checker from blocking legitimate requests
      return true;
    }
  }
} 