import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/login/data/models/login_request_model.dart';
import 'package:wejha/features/auth/login/domain/usecases/login.dart';
import 'package:wejha/features/auth/login/domain/usecases/refresh_token.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_event.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final RefreshToken refreshToken;
  
  // Form model to persist form state
  LoginRequestModel _formModel =  LoginRequestModel(email: '', password: '');
  LoginRequestModel get formModel => _formModel;

  LoginBloc({
    required this.login,
    required this.refreshToken,
  }) : super(LoginInitial()) {
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPassword);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<UpdateLoginFormEvent>(_onUpdateLoginForm);
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
} 