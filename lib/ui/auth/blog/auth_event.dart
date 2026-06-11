abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitted(this.username, this.password);
}

class LogoutPressed extends AuthEvent {}

class AppStarted extends AuthEvent {}

class UpdateFcmTokenEvent extends AuthEvent {
  final String token;
  UpdateFcmTokenEvent(this.token);
}

class ChangePasswordSubmitted extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}

class ForgotPasswordRequested extends AuthEvent {
  final String identifier;

  ForgotPasswordRequested(this.identifier);
}
