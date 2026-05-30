import 'dart:ui';

abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitted(this.username, this.password);
}

class LogoutPressed extends AuthEvent {}

class LanguageChanged extends AuthEvent {
  final Locale locale;

  LanguageChanged(this.locale);
}

class AppStarted extends AuthEvent {}

class UpdateFcmTokenEvent extends AuthEvent {
  final String token;
  UpdateFcmTokenEvent(this.token);
}
