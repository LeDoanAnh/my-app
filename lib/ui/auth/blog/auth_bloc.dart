import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutPressed>(_onLogoutPressed);
    on<AppStarted>(_onAppStarted);
    on<UpdateFcmTokenEvent>(_onUpdateFcmTokenEvent);
  }

  Future<void> _onUpdateFcmTokenEvent(
    UpdateFcmTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print("token FCM ở bloc: ${event.token}");
      print("FCM Token updated via Bloc Event");
      await repository.saveFcmToken(event.token);
    } catch (e) {
      print("Error updating token in Bloc: $e");
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(event.username, event.password);
      await repository.saveUserToLocal(user);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutPressed(
    LogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(Unauthenticated());
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final currentUser = await repository.getUserFromLocal();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
    } else {
      emit(Unauthenticated());
    }
  }
}
