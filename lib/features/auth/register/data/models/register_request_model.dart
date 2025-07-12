import 'dart:convert';

class RegisterRequestModel {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;
  final String birthday;
  final String? fname;
  final String? lname;
  final String? roleId;
  final String? photo;

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.gender,
    required this.birthday,
    this.fname,
    this.lname,
    this.roleId,
    this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      if (fname != null) 'fname': fname,
      if (lname != null) 'lname': lname,
      if (roleId != null) 'role_id': roleId,
      if (photo != null) 'photo': photo,
    };
  }

  String toJsonString() => json.encode(toJson());

  // Add copyWith method to maintain state
  RegisterRequestModel copyWith({
    String? email,
    String? password,
    String? passwordConfirmation,
    String? phone,
    String? gender,
    String? birthday,
    String? fname,
    String? lname,
    String? roleId,
    String? photo,
  }) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      roleId: roleId ?? this.roleId,
      photo: photo ?? this.photo,
    );
  }
}
