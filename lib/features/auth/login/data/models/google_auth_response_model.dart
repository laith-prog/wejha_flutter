class GoogleAuthResponseModel {
  final String message;
  final String redirectUrl;

  GoogleAuthResponseModel({
    required this.message,
    required this.redirectUrl,
  });

  factory GoogleAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleAuthResponseModel(
      message: json['message'],
      redirectUrl: json['redirect_url'],
    );
  }
} 