import 'dart:convert';

class RefreshTokenRequestModel {
  final String refreshToken;

  RefreshTokenRequestModel({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }

  String toJsonString() => json.encode(toJson());
} 