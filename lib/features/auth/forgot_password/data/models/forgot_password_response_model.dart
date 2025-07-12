class ForgotPasswordResponseModel {
  final String message;
  final String status;
  final ForgotPasswordDataModel data;

  ForgotPasswordResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'],
      status: json['status'],
      data: ForgotPasswordDataModel.fromJson(json['data']),
    );
  }
}

class ForgotPasswordDataModel {
  final String email;
  final int expiresIn;
  final String mailDriver;

  ForgotPasswordDataModel({
    required this.email,
    required this.expiresIn,
    required this.mailDriver,
  });

  factory ForgotPasswordDataModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordDataModel(
      email: json['email'],
      expiresIn: json['expires_in'],
      mailDriver: json['mail_driver'],
    );
  }
} 