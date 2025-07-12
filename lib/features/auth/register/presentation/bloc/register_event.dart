import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SendVerificationCodeEvent extends RegisterEvent {
  final String fname;
  final String lname;
  final String email;

  const SendVerificationCodeEvent({
    required this.fname,
    required this.lname,
    required this.email,
  });

  @override
  List<Object?> get props => [fname, lname, email];
}

class VerifyCodeEvent extends RegisterEvent {
  final String email;
  final String code;

  const VerifyCodeEvent({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

class CompleteRegistrationEvent extends RegisterEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;
  final String birthday;
  final String? roleId;
  final String? photo;

  const CompleteRegistrationEvent({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.gender,
    required this.birthday,
    this.roleId,
    this.photo,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,
    phone,
    gender,
    birthday,
    roleId,
    photo,
  ];
}

// Add event to update form fields individually
class UpdateRegisterFormEvent extends RegisterEvent {
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final String? phone;
  final String? gender;
  final String? birthday;
  final String? fname;
  final String? lname;
  final String? roleId;
  final String? photo;

  const UpdateRegisterFormEvent({
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phone,
    this.gender,
    this.birthday,
    this.fname,
    this.lname,
    this.roleId,
    this.photo,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,
    phone,
    gender,
    birthday,
    fname,
    lname,
    roleId,
    photo,
  ];
}
