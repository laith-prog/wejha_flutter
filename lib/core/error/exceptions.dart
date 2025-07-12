class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ValidationException({required this.message, this.errors});
}

class ConnectionException implements Exception {
  final String message;

  ConnectionException({required this.message});
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});
} 