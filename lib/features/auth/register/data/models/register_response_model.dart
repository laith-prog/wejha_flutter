import '../../domain/entities/register_response.dart' as entities;
import '../../domain/entities/user.dart' as user_entity;
import '../../../../../core/utils/url_helper.dart';

class RegisterResponseModel {
  final String message;
  final String status;
  final RegisterResponseDataModel data;

  RegisterResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'],
      status: json['status'],
      data: RegisterResponseDataModel.fromJson(json['data']),
    );
  }

  entities.RegisterResponse toEntity() {
    return entities.RegisterResponse(
      message: message,
      status: status,
      data: data.toEntity(),
    );
  }
}

class RegisterResponseDataModel {
  final UserModel user;
  final TokensModel tokens;

  RegisterResponseDataModel({
    required this.user,
    required this.tokens,
  });

  factory RegisterResponseDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDataModel(
      user: UserModel.fromJson(json['user']),
      tokens: TokensModel.fromJson(json['tokens']),
    );
  }

  entities.RegisterResponseData toEntity() {
    return entities.RegisterResponseData(
      user: user.toEntity(),
      tokens: tokens.toEntity(),
    );
  }
}

class TokensModel {
  final String accessToken;
  final String refreshToken;
  TokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  entities.Tokens toEntity() {
    return entities.Tokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

class UserModel {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String role;
  final String? photo;

  UserModel({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.role,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      role: json['role'].toString(),
      photo: json['photo'] != null ? UrlHelper.formatImageUrl(json['photo']) : null,
    );
  }

  user_entity.User toEntity() {
    return user_entity.User(
      id: id,
      fname: fname,
      lname: lname,
      email: email,
      role: role,
      photo: photo,
    );
  }
} 