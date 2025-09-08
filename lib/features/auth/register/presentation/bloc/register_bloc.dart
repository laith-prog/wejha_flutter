import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejha/features/auth/register/data/models/register_request_model.dart';
import 'package:wejha/features/auth/register/domain/usecases/complete_registration.dart';
import 'package:wejha/features/auth/register/domain/usecases/send_verification_code.dart';
import 'package:wejha/features/auth/register/domain/usecases/verify_code.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SendVerificationCode sendVerificationCode;
  final VerifyCode verifyCode;
  final CompleteRegistration completeRegistration;
  
  // Add form model to maintain state across registration steps
  RegisterRequestModel _formModel = RegisterRequestModel(
    email: '',
    password: '',
    passwordConfirmation: '',
    phone: '',
    gender: 'male',
    birthday: '',
  );

  RegisterBloc({
    required this.sendVerificationCode,
    required this.verifyCode,
    required this.completeRegistration,
  }) : super(RegisterInitial()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<CompleteRegistrationEvent>(_onCompleteRegistration);
    on<UpdateRegisterFormEvent>(_onUpdateRegisterForm);
  }
  
  // Getter for the current form state
  RegisterRequestModel get formModel => _formModel;

  Future<void> _onSendVerificationCode(
    SendVerificationCodeEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(VerificationCodeSending());
    
    // Update form model with step one data
    _formModel = _formModel.copyWith(
      email: event.email,
      fname: event.fname,
      lname: event.lname,
    );

    final result = await sendVerificationCode(
      SendVerificationCodeParams(
        fname: event.fname,
        lname: event.lname,
        email: event.email,
      ),
    );

    result.fold(
      (failure) => emit(VerificationCodeError(failure: failure)),
      (message) => emit(VerificationCodeSent(message: message)),
    );
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(CodeVerifying());
    
    // Update form model with email if provided
    if (event.email.isNotEmpty) {
      _formModel = _formModel.copyWith(email: event.email);
    }

    final result = await verifyCode(
      VerifyCodeParams(
        email: _formModel.email, // Use email from form model
        code: event.code,
      ),
    );

    result.fold(
      (failure) => emit(CodeVerificationError(failure: failure)),
      (message) => emit(CodeVerified(message: message)),
    );
  }

  Future<void> _onCompleteRegistration(
    CompleteRegistrationEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegistrationCompleting());
    
    // Update form model with step three data
    _formModel = _formModel.copyWith(
      email: event.email.isNotEmpty ? event.email : _formModel.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phone: event.phone,
      gender: event.gender,
      birthday: event.birthday,
      roleId: event.roleId,
      photo: event.photo,
    );

    final result = await completeRegistration(
      CompleteRegistrationParams(
        email: _formModel.email,
        password: _formModel.password,
        passwordConfirmation: _formModel.passwordConfirmation,
        phone: _formModel.phone,
        gender: _formModel.gender,
        birthday: _formModel.birthday,
        roleId: _formModel.roleId,
        photo: _formModel.photo,
      ),
    );

    result.fold(
      (failure) => emit(RegistrationError(failure: failure)),
      (response) {
        // Don't store tokens, just emit completion state
        emit(RegistrationCompleted(registerResponse: response));
      },
    );
  }
  
  // Add method to update form fields individually
  void _onUpdateRegisterForm(
    UpdateRegisterFormEvent event,
    Emitter<RegisterState> emit,
  ) {
    _formModel = _formModel.copyWith(
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phone: event.phone,
      gender: event.gender,
      birthday: event.birthday,
      fname: event.fname,
      lname: event.lname,
      roleId: event.roleId,
      photo: event.photo,
    );
    
    emit(RegisterFormUpdated(formModel: _formModel));
  }
}