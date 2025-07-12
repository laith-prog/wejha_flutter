import '../../../../../core/utils/url_helper.dart';

class LoginResponseModel {
  final String message;
  final String status;
  final LoginResponseDataModel data;

  LoginResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      status: json['status'],
      data: LoginResponseDataModel.fromJson(json['data']),
    );
  }
}

class LoginResponseDataModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  LoginResponseDataModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginResponseDataModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseDataModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 900, // Default to 15 minutes if not provided
    );
  }
}

class UserModel {
  final String id;
  final String fname;
  final String lname;
  final String type;
  final String email;
  final String emailVerifiedAt;
  final String phone;
  final String gender;
  final String birthday;
  final String authProvider;
  final String? photo;
  final int? roleId;
  final String? refreshTokenExpiresAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  UserModel({
    required this.id,
    required this.fname,
    required this.lname,
    required this.type,
    required this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.authProvider,
    this.photo,
    this.roleId,
    this.refreshTokenExpiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      type: json['type'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phone: json['phone'],
      gender: json['gender'],
      birthday: json['birthday'],
      authProvider: json['auth_provider'],
      photo: json['photo'] != null ? UrlHelper.formatImageUrl(json['photo']) : null,
      roleId: json['role_id'],
      refreshTokenExpiresAt: json['refresh_token_expires_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
} 