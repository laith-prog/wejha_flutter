import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/services/token_manager.dart';
import 'package:wejha/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_event.dart';
import 'package:wejha/features/splash/presentation/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final TokenManager tokenManager;
  final Dio dio;
  final LoginBloc loginBloc;

  SplashBloc({
    required this.tokenManager,
    required this.dio,
    required this.loginBloc,
  }) : super(SplashInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(CheckingAuthState());

    try {
      // Check if user is logged in
      if (!tokenManager.isLoggedIn()) {
        debugPrint('User is not logged in');
        emit(UnauthenticatedState());
        return;
      }

      // Check if token is valid by making a test request
      final token = tokenManager.getAuthorizationHeader();
      if (token == null) {
        debugPrint('Token is null');
        emit(UnauthenticatedState());
        return;
      }

      try {
        debugPrint('Testing auth token validity with token: $token');
        final response = await dio.get(
          ApiConstants.authTest,
          options: Options(
            headers: {
              'Authorization': token,
            },
          ),
        );

        debugPrint('Auth test response: ${response.statusCode}');
        debugPrint('Auth test data: ${response.data}');

        if (response.statusCode == 200) {
          emit(AuthenticatedState(token: token));
        } else {
          // Token is invalid, try to refresh
          final refreshSuccess = await tokenManager.refreshTokenIfNeeded(loginBloc);
          if (refreshSuccess) {
            final newToken = tokenManager.getAuthorizationHeader();
            if (newToken != null) {
              emit(AuthenticatedState(token: newToken));
            } else {
              emit(UnauthenticatedState());
            }
          } else {
            emit(UnauthenticatedState());
          }
        }
      } on DioException catch (e) {
        debugPrint('DioException during auth test: ${e.message}');
        debugPrint('DioException type: ${e.type}');
        debugPrint('DioException response: ${e.response?.data}');

        if (e.response?.statusCode == 401) {
          // Token is invalid, try to refresh
          final refreshSuccess = await tokenManager.refreshTokenIfNeeded(loginBloc);
          if (refreshSuccess) {
            final newToken = tokenManager.getAuthorizationHeader();
            if (newToken != null) {
              emit(AuthenticatedState(token: newToken));
            } else {
              emit(UnauthenticatedState());
            }
          } else {
            emit(UnauthenticatedState());
          }
        } else {
          emit(AuthErrorState(message: e.message ?? 'Network error occurred'));
        }
      } catch (e) {
        debugPrint('General exception during auth test: $e');
        emit(AuthErrorState(message: e.toString()));
      }
    } catch (e) {
      debugPrint('Exception in _onCheckAuthStatus: $e');
      emit(AuthErrorState(message: 'Authentication check failed'));
    }
  }
} 