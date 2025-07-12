import '../../domain/entities/profile_response.dart';
import 'profile_model.dart';

class ProfileResponseModel extends ProfileResponse {
  const ProfileResponseModel({
    required super.message,
    required super.status,
    required super.user,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      message: json['message'],
      status: json['status'],
      user: ProfileModel.fromJson(json['data']['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': {
        'user': (user as ProfileModel).toJson(),
      },
    };
  }
} 