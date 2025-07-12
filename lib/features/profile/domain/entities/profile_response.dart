import 'package:equatable/equatable.dart';
import 'profile.dart';

class ProfileResponse extends Equatable {
  final String message;
  final String status;
  final Profile user;

  const ProfileResponse({
    required this.message,
    required this.status,
    required this.user,
  });

  @override
  List<Object?> get props => [message, status, user];
} 