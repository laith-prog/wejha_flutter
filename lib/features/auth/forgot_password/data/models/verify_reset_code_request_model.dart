import 'dart:convert';

class VerifyResetCodeRequestModel {
  final String email;
  final String code;

  VerifyResetCodeRequestModel({
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