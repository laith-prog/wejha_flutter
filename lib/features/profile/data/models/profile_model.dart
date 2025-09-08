import '../../domain/entities/profile.dart';
import '../../../../core/utils/url_helper.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.fname,
    required super.lname,
    required super.email,
    super.phone,
    super.gender,
    super.birthday,
    super.photo,
    required super.role,
    required super.roleId,
    super.emailVerifiedAt,
    required super.authProvider,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      photo: json['photo'] != null ? UrlHelper.formatImageUrl(json['photo']) : null,
      role: json['role'],
      roleId: json['role_id'],
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at']) : null,
      authProvider: json['auth_provider'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'photo': photo,
      'role': role,
      'role_id': roleId,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 