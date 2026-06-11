abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final dynamic user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated({this.message});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class ForgotPasswordSent extends AuthState {}
