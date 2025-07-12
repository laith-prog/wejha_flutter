import 'package:equatable/equatable.dart';
import 'package:wejha/core/error/failures.dart';
import '../../domain/entities/profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileResponse profileResponse;

  const ProfileLoaded({required this.profileResponse});

  @override
  List<Object?> get props => [profileResponse];
}

class ProfileError extends ProfileState {
  final Failure failure;

  const ProfileError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class LogoutLoading extends ProfileState {
  const LogoutLoading();
}

class LogoutSuccess extends ProfileState {
  const LogoutSuccess();
}

class LogoutError extends ProfileState {
  final Failure failure;

  const LogoutError({required this.failure});

  @override
  List<Object?> get props => [failure];
} 