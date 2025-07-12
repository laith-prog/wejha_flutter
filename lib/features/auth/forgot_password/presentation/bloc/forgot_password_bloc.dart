import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/forgot_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/reset_password.dart';
import 'package:wejha/features/auth/forgot_password/domain/usecases/verify_reset_code.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:wejha/features/auth/forgot_password/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPassword forgotPassword;
  final VerifyResetCode verifyResetCode;
  final ResetPassword resetPassword;

  ForgotPasswordBloc({
    required this.forgotPassword,
    required this.verifyResetCode,
    required this.resetPassword,
  }) : super(ForgotPasswordInitial()) {
    on<SendForgotPasswordEmailEvent>(_onSendForgotPasswordEmail);
    on<VerifyResetCodeEvent>(_onVerifyResetCode);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendForgotPasswordEmail(
    SendForgotPasswordEmailEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(SendingForgotPasswordEmail());

    final result = await forgotPassword(
      ForgotPasswordParams(
        email: event.email,
      ),
    );

    result.fold(
      (failure) => emit(ForgotPasswordEmailError(failure: failure)),
      (response) => emit(ForgotPasswordEmailSent(response: response)),
    );
  }

  Future<void> _onVerifyResetCode(
    VerifyResetCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(VerifyingResetCode());

    final result = await verifyResetCode(
      VerifyResetCodeParams(
        email: event.email,
        code: event.code,
      ),
    );

    result.fold(
      (failure) => emit(ResetCodeError(failure: failure)),
      (response) => emit(ResetCodeVerified(response: response)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ResettingPassword());

    final result = await resetPassword(
      ResetPasswordParams(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      ),
    );

    result.fold(
      (failure) => emit(PasswordResetError(failure: failure)),
      (response) => emit(PasswordResetSuccess(response: response)),
    );
  }
} 