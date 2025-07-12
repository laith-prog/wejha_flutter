import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithEmailPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginWithGoogleEvent extends LoginEvent {
  const LoginWithGoogleEvent();

  @override
  List<Object?> get props => [];
}

class LogoutEvent extends LoginEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class RefreshTokenEvent extends LoginEvent {
  final String refreshToken;

  const RefreshTokenEvent({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}

// Add event to update form fields individually
class UpdateLoginFormEvent extends LoginEvent {
  final String? email;
  final String? password;

  const UpdateLoginFormEvent({
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Add event for handling Google OAuth callback
class HandleGoogleOAuthCallbackEvent extends LoginEvent {
  final Uri uri;

  const HandleGoogleOAuthCallbackEvent({required this.uri});

  @override
  List<Object?> get props => [uri];
} 