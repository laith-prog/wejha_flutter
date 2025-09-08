import 'package:equatable/equatable.dart';
import 'package:wejha/features/auth/google_auth/data/models/google_auth_response_model.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object?> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthCallbackSuccess extends GoogleAuthState {
  final GoogleAuthResponseModel response;
  final bool isNewUser;
  final String existingLastName;

  const GoogleAuthCallbackSuccess({
    required this.response, 
    required this.isNewUser,
    this.existingLastName = '',
  });

  @override
  List<Object?> get props => [response, isNewUser, existingLastName];
}

class ProfileCompleted extends GoogleAuthState {
  const ProfileCompleted();
}

class GoogleAuthError extends GoogleAuthState {
  final String message;

  const GoogleAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}