class VerifyResetCodeResponseModel {
  final String message;
  final String status;
  final VerifyResetCodeDataModel data;

  VerifyResetCodeResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory VerifyResetCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeResponseModel(
      message: json['message'],
      status: json['status'],
      data: VerifyResetCodeDataModel.fromJson(json['data']),
    );
  }
}

class VerifyResetCodeDataModel {
  final String email;
  final bool canResetPassword;

  VerifyResetCodeDataModel({
    required this.email,
    required this.canResetPassword,
  });

  factory VerifyResetCodeDataModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeDataModel(
      email: json['email'],
      canResetPassword: json['can_reset_password'],
    );
  }
} 