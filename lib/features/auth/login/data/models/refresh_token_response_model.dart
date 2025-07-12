class RefreshTokenResponseModel {
  final String message;
  final String status;
  final RefreshTokenDataModel data;

  RefreshTokenResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      message: json['message'],
      status: json['status'],
      data: RefreshTokenDataModel.fromJson(json['data']),
    );
  }
}

class RefreshTokenDataModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  RefreshTokenDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory RefreshTokenDataModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenDataModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
} 