import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_state.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';
  static const String _tokenExpiryTimeKey = 'token_expiry_time';

  final SharedPreferences _prefs;

  TokenManager(this._prefs);

  // Save tokens
  Future<void> saveTokens(AuthToken authToken) async {
    await _prefs.setString(_accessTokenKey, authToken.accessToken);
    await _prefs.setString(_refreshTokenKey, authToken.refreshToken);
    await _prefs.setString(_tokenTypeKey, authToken.tokenType);
    await _prefs.setInt(_expiresInKey, authToken.expiresIn);
    
    // Calculate and save expiry time
    final expiryTime = DateTime.now().add(Duration(seconds: authToken.expiresIn));
    await _prefs.setString(_tokenExpiryTimeKey, expiryTime.toIso8601String());
    
    debugPrint('Tokens saved. Expires at: ${expiryTime.toIso8601String()}');
  }

  // Get access token
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  // Get token type
  String? getTokenType() {
    return _prefs.getString(_tokenTypeKey);
  }

  // Get full authorization header
  String? getAuthorizationHeader() {
    final accessToken = getAccessToken();
    
    if (accessToken != null) {
      // Always use 'Bearer' format for JWT tokens
      return 'Bearer $accessToken';
    }
    return null;
  }

  // Check if token is expired
  bool isTokenExpired() {
    final expiryTimeString = _prefs.getString(_tokenExpiryTimeKey);
    if (expiryTimeString == null) {
      return true;
    }
    
    final expiryTime = DateTime.parse(expiryTimeString);
    final now = DateTime.now();
    
    // Return true if current time is after expiry time or within 60 seconds of expiry
    return now.isAfter(expiryTime) || 
           now.isAfter(expiryTime.subtract(const Duration(seconds: 60)));
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getAccessToken() != null && getRefreshToken() != null;
  }

  // Clear tokens on logout
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_tokenTypeKey);
    await _prefs.remove(_expiresInKey);
    await _prefs.remove(_tokenExpiryTimeKey);
  }

  // Get current auth token
  AuthToken? getCurrentAuthToken() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();
    final tokenType = getTokenType();
    final expiresIn = _prefs.getInt(_expiresInKey);
    
    if (accessToken != null && refreshToken != null && tokenType != null && expiresIn != null) {
      return AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
        expiresIn: expiresIn,
      );
    }
    return null;
  }

  // Refresh token if needed
  Future<bool> refreshTokenIfNeeded(LoginBloc loginBloc) async {
    if (!isLoggedIn()) {
      return false;
    }
    
    if (isTokenExpired()) {
      debugPrint('Token expired. Refreshing...');
      final refreshToken = getRefreshToken();
      
      if (refreshToken != null) {
        loginBloc.add(RefreshTokenEvent(refreshToken: refreshToken));
        
        // Wait for the refresh token process to complete
        bool success = false;
        
        // Create a subscription to listen for state changes
        final subscription = loginBloc.stream.listen((state) {
          if (state is RefreshTokenSuccess) {
            saveTokens(state.refreshTokenResponse.authToken);
            success = true;
          } else if (state is RefreshTokenError) {
            debugPrint('Failed to refresh token: ${state.failure.message}');
            clearTokens();
            success = false;
          }
        });
        
        // Wait for the refresh token process to complete or timeout after 5 seconds
        await Future.delayed(const Duration(seconds: 5));
        
        // Clean up the subscription
        await subscription.cancel();
        
        return success;
      }
      return false;
    }
    
    return true;
  }
} 