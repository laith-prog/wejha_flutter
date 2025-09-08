import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
  });

  @override
  List<Object> get props => [message, if (errors != null) errors!];
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'No internet connection');
} 