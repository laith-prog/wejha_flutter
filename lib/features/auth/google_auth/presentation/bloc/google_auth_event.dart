import 'package:equatable/equatable.dart';

abstract class GoogleAuthEvent extends Equatable {
  const GoogleAuthEvent();

  @override
  List<Object?> get props => [];
}

class FirebaseGoogleAuthEvent extends GoogleAuthEvent {
  final String idToken;
  
  const FirebaseGoogleAuthEvent({required this.idToken});
  
  @override
  List<Object?> get props => [idToken];
}

class CompleteProfileEvent extends GoogleAuthEvent {
  final String userId;
  final int roleId;
  final String phone;
  final String gender;
  final String birthday;
  final String lname;
  final String? photo;

  const CompleteProfileEvent({
    required this.userId,
    required this.roleId,
    required this.phone,
    required this.gender,
    required this.birthday,
    this.lname = '', // Default to empty string
    this.photo,
  });

  @override
  List<Object?> get props => [userId, roleId, phone, gender, birthday, lname, photo];
} 