import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/logout.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final Logout logout;

  ProfileBloc({
    required this.getProfile,
    required this.logout,
  }) : super(const ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getProfile();

    result.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profileResponse) => emit(ProfileLoaded(profileResponse: profileResponse)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const LogoutLoading());

    final result = await logout();

    result.fold(
      (failure) => emit(LogoutError(failure: failure)),
      (_) => emit(const LogoutSuccess()),
    );
  }
} 