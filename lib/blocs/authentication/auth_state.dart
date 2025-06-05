import 'package:equatable/equatable.dart';


class AuthUser {
  final String name;
  final String email;
  final String language;

  AuthUser({
    required this.name,
    required this.email,
    required this.language,
  });
}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user.name, user.email, user.language];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {}
