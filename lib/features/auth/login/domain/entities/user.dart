import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fname;
  final String lname;
  final String role;
  final String roleId;
  final String email;
  final String emailVerifiedAt;
  final String phone;
  final String gender;
  final String birthday;
  final String authProvider;
  final String? photo;
  final String? refreshTokenExpiresAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.role,
    required this.roleId,
    required this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.authProvider,
    this.photo,
    this.refreshTokenExpiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fname,
        lname,
        role,
        roleId,
        email,
        emailVerifiedAt,
        phone,
        gender,
        birthday,
        authProvider,
        photo,
        refreshTokenExpiresAt,
        createdAt,
        updatedAt,
        deletedAt,
      ];
} 