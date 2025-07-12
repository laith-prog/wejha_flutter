import 'dart:convert';

class VerificationRequestModel {
  final String fname;
  final String lname;
  final String email;

  VerificationRequestModel({
    required this.fname,
    required this.lname,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
    };
  }

  String toJsonString() => json.encode(toJson());
} 