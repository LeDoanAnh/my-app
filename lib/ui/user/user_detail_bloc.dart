import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/repositories/user_repository.dart';
import 'package:my_app/ui/user/user_detail_event.dart';
import 'package:my_app/ui/user/user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repository;

  UserDetailBloc(this.repository) : super(UserDetailInitial()) {
    on<GetUserDetail>(_getUserDetail);
    on<DeactivateUser>(_deactivateUser);
  }

  Future<void> _getUserDetail(
    GetUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());

    try {
      final user = await repository.getUserDetail(event.userId);
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }

  Future<void> _deactivateUser(
    DeactivateUser event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());

    try {
      await repository.deactivateUser(event.userId);
      final user = await repository.getUserDetail(event.userId);
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }
}
