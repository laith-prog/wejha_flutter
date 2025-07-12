import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class CheckingAuthState extends SplashState {}

class AuthenticatedState extends SplashState {
  final String token;

  const AuthenticatedState({required this.token});

  @override
  List<Object?> get props => [token];
}

class UnauthenticatedState extends SplashState {}

class AuthErrorState extends SplashState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
} 