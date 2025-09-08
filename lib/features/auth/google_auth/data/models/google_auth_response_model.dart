import 'package:equatable/equatable.dart';
import 'package:wejha/features/auth/login/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String fname,
    required String lname,
    required String role,
    required String roleId,
    required String email,
    required String emailVerifiedAt,
    required String phone,
    required String gender,
    required String birthday,
    required String authProvider,
    String? photo,
    String? refreshTokenExpiresAt,
    required String createdAt,
    required String updatedAt,
    String? deletedAt,
  }) : super(
    id: id,
    fname: fname,
    lname: lname,
    role: role,
    roleId: roleId,
    email: email,
    emailVerifiedAt: emailVerifiedAt,
    phone: phone,
    gender: gender,
    birthday: birthday,
    authProvider: authProvider,
    photo: photo,
    refreshTokenExpiresAt: refreshTokenExpiresAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String? ?? '', // Handle null lname
      role: json['role'] ?? 'user',
      roleId: json['role_id']?.toString() ?? '0', // Handle null roleId
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      authProvider: json['auth_provider'] as String? ?? 'google', // Handle missing auth_provider
      photo: json['photo'] as String?,
      refreshTokenExpiresAt: json['refresh_token_expires_at'] as String?,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(), // Handle missing created_at
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(), // Handle missing updated_at
      deletedAt: json['deleted_at'] as String?,
    );
  }
}

class GoogleAuthResponseModel extends Equatable {
  final String status;
  final String message;
  final bool? isNewUser;
  final GoogleUserData? googleUserData;
  final GoogleAuthData data;

  const GoogleAuthResponseModel({
    required this.status,
    required this.message,
    this.isNewUser,
    this.googleUserData,
    required this.data,
  });

  factory GoogleAuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Determine if this is a new user based on the message or missing tokens
    final message = json['message'] as String;
    final isNewUserMessage = message.contains('registration');
    final data = GoogleAuthData.fromJson(json['data'] as Map<String, dynamic>);
    final isNewUser = isNewUserMessage || (data.accessToken == null && !message.contains('completed successfully'));
    
    return GoogleAuthResponseModel(
      status: json['status'] as String,
      message: message,
      isNewUser: isNewUser,
      googleUserData: json.containsKey('google_user_data') 
          ? GoogleUserData.fromJson(json['google_user_data'] as Map<String, dynamic>)
          : null,
      data: data,
    );
  }

  @override
  List<Object?> get props => [status, message, isNewUser, googleUserData, data];
}

class GoogleUserData extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatar;

  const GoogleUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory GoogleUserData.fromJson(Map<String, dynamic> json) {
    return GoogleUserData(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatar];
}

class GoogleAuthData extends Equatable {
  final UserModel user;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  const GoogleAuthData({
    required this.user,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory GoogleAuthData.fromJson(Map<String, dynamic> json) {
    return GoogleAuthData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, tokenType, expiresIn];
} 