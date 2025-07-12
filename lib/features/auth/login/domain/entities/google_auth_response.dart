import 'package:equatable/equatable.dart';

class GoogleAuthResponse extends Equatable {
  final String message;
  final String redirectUrl;

  const GoogleAuthResponse({
    required this.message,
    required this.redirectUrl,
  });

  @override
  List<Object?> get props => [message, redirectUrl];
} 