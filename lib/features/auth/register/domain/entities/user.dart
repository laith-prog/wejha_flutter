import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String role;
  final String? photo;

  const User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.role,
    this.photo,
  });

  @override
  List<Object?> get props => [
        id,
        fname,
        lname,
        email,
        role,
        photo,
      ];
} 