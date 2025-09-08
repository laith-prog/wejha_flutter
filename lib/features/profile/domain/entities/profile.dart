import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String? phone;
  final String? gender;
  final DateTime? birthday;
  final String? photo;
  final String role;
  final String roleId;
  final DateTime? emailVerifiedAt;
  final String authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    this.phone,
    this.gender,
    this.birthday,
    this.photo,
    required this.role,
    required this.roleId,
    this.emailVerifiedAt,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fname,
        lname,
        email,
        phone,
        gender,
        birthday,
        photo,
        role,
        roleId,
        emailVerifiedAt,
        authProvider,
        createdAt,
        updatedAt,
      ];
} 