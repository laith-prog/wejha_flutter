import 'dart:convert';

class VerificationCodeRequestModel {
  final String email;
  final String code;

  VerificationCodeRequestModel({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }

  String toJsonString() => json.encode(toJson());
} 