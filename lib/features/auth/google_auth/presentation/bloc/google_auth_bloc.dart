import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/core/usecases/usecase.dart';
import 'package:wejha/features/auth/login/domain/entities/auth_token.dart';
import 'package:wejha/features/auth/google_auth/domain/usecases/complete_profile.dart';
import 'package:wejha/features/auth/google_auth/domain/usecases/firebase_google_auth.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_event.dart';
import 'package:wejha/features/auth/google_auth/presentation/bloc/google_auth_state.dart';
import 'package:wejha/injection_container.dart' as di;

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final CompleteProfile completeProfile;
  final FirebaseGoogleAuth firebaseGoogleAuth;
  final TokenManager _tokenManager = di.sl<TokenManager>();

  GoogleAuthBloc({
    required this.completeProfile,
    required this.firebaseGoogleAuth,
  }) : super(const GoogleAuthInitial()) {
    on<CompleteProfileEvent>(_onCompleteProfile);
    on<FirebaseGoogleAuthEvent>(_onFirebaseGoogleAuth);
  }

  Future<void> _onCompleteProfile(
    CompleteProfileEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(const GoogleAuthLoading());
    
    final result = await completeProfile(CompleteProfileParams(
      userId: event.userId,
      roleId: event.roleId,
      phone: event.phone,
      gender: event.gender,
      birthday: event.birthday,
      lname: event.lname,
      photo: event.photo,
    ));
    
    emit(result.fold(
      (failure) => GoogleAuthError(message: failure.message),
      (response) {
        // Save tokens if available
        _saveTokensIfAvailable(response);
        return const ProfileCompleted();
      },
    ));
  }

  Future<void> _onFirebaseGoogleAuth(
    FirebaseGoogleAuthEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(const GoogleAuthLoading());
    
    final result = await firebaseGoogleAuth(
      FirebaseGoogleAuthParams(idToken: event.idToken),
    );
    
    emit(result.fold(
      (failure) => GoogleAuthError(message: failure.message),
      (response) {
        // Save tokens if available
        _saveTokensIfAvailable(response);
        return GoogleAuthCallbackSuccess(
          response: response,
          isNewUser: response.isNewUser ?? false,
          existingLastName: response.data.user.lname,
        );
      },
    ));
  }

  // Helper method to save tokens
  void _saveTokensIfAvailable(response) {
    if (response.data.accessToken != null && response.data.refreshToken != null) {
      debugPrint('Saving tokens from Google Auth response');
      final authToken = AuthToken(
        accessToken: response.data.accessToken!,
        refreshToken: response.data.refreshToken!,
        tokenType: response.data.tokenType ?? 'Bearer',
        expiresIn: response.data.expiresIn ?? 3600,
      );
      _tokenManager.saveTokens(authToken);
    } else {
      debugPrint('No tokens available to save from Google Auth response');
    }
  }
} 