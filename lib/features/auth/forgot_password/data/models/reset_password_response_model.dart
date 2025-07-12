import 'package:wejha/features/auth/login/data/models/login_response_model.dart';

class ResetPasswordResponseModel {
  final String message;
  final String status;
  final ResetPasswordDataModel data;

  ResetPasswordResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'],
      status: json['status'],
      data: ResetPasswordDataModel.fromJson(json['data']),
    );
  }
}

class ResetPasswordDataModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  ResetPasswordDataModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory ResetPasswordDataModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordDataModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
} 