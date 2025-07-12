import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/data/models/login_request_model.dart';
import 'package:wejha/features/auth/login/domain/usecases/get_google_auth_url.dart';
import 'package:wejha/features/auth/login/domain/usecases/login.dart';
import 'package:wejha/features/auth/login/domain/usecases/refresh_token.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_state.dart';

import '../../domain/usecases/handle_google_oauth_callback.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final GetGoogleAuthUrl getGoogleAuthUrl;
  final RefreshToken refreshToken;
  final HandleGoogleOAuthCallback handleGoogleOAuthCallback;
  
  // Form model to persist form state
  LoginRequestModel _formModel =  LoginRequestModel(email: '', password: '');
  LoginRequestModel get formModel => _formModel;

  LoginBloc({
    required this.login,
    required this.getGoogleAuthUrl,
    required this.refreshToken,
    required this.handleGoogleOAuthCallback,
  }) : super(LoginInitial()) {
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPassword);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<UpdateLoginFormEvent>(_onUpdateLoginForm);
    on<HandleGoogleOAuthCallbackEvent>(_onHandleGoogleOAuthCallback);
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    // Update form model with latest values
    _formModel = _formModel.copyWith(
      email: event.email,
      password: event.password,
    );

    final result = await login(
      LoginParams(
        email: _formModel.email,
        password: _formModel.password,
      ),
    );

    result.fold(
      (failure) => emit(LoginError(failure: failure)),
      (loginResponse) => emit(LoginSuccess(loginResponse: loginResponse)),
    );
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(GoogleAuthLoading());

    final result = await getGoogleAuthUrl();

    result.fold(
      (failure) => emit(GoogleAuthError(failure: failure)),
      (googleAuthResponse) async {
        // Use the URL launcher service to open the URL in the browser
        final url = googleAuthResponse.redirectUrl;
        
        debugPrint('Opening Google Auth URL: $url');
        
        try {
          // Launch the URL directly in the external browser
          final Uri uri = Uri.parse(url);
          final bool canLaunch = await url_launcher.canLaunchUrl(uri);
          
          if (canLaunch) {
            final bool launched = await url_launcher.launchUrl(
              uri,
              mode: url_launcher.LaunchMode.externalApplication,
            );
            
            if (launched) {
              emit(GoogleAuthSuccess(googleAuthResponse: googleAuthResponse));
            } else {
              emit(GoogleAuthError(failure: ServerFailure(message: 'Could not launch URL')));
            }
          } else {
            emit(GoogleAuthError(failure: ServerFailure(message: 'Cannot launch URL: $url')));
          }
        } catch (e) {
          debugPrint('Error launching URL: $e');
          emit(GoogleAuthError(failure: ServerFailure(message: 'Error launching URL: $e')));
        }
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<LoginState> emit,
  ) async {
    // Reset form model on logout
    _formModel = LoginRequestModel(email: '', password: '');
    emit(LogoutSuccess());
  }
  
  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(RefreshTokenLoading());

    final result = await refreshToken(
      RefreshTokenParams(
        refreshToken: event.refreshToken,
      ),
    );

    result.fold(
      (failure) => emit(RefreshTokenError(failure: failure)),
      (response) => emit(RefreshTokenSuccess(refreshTokenResponse: response)),
    );
  }
  
  // Add method to update form fields individually
  void _onUpdateLoginForm(
    UpdateLoginFormEvent event,
    Emitter<LoginState> emit,
  ) {
    _formModel = _formModel.copyWith(
      email: event.email,
      password: event.password,
    );
    
    emit(LoginFormUpdated(formModel: _formModel));
  }

  // Add method to handle Google OAuth callbacks
  Future<void> _onHandleGoogleOAuthCallback(
    HandleGoogleOAuthCallbackEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(GoogleOAuthCallbackProcessing());
    
    debugPrint('Handling Google OAuth callback in bloc: ${event.uri}');

    final result = await handleGoogleOAuthCallback(
      GoogleOAuthCallbackParams(uri: event.uri),
    );

    result.fold(
      (failure) {
        debugPrint('Google OAuth callback failed: ${failure.message}');
        emit(GoogleOAuthCallbackError(failure: failure));
      },
      (loginResponse) {
        debugPrint('Google OAuth callback succeeded');
        emit(GoogleOAuthCallbackSuccess(loginResponse: loginResponse));
      },
    );
  }
} 