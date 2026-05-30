import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/create_user_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/user/form_user/form_user_event.dart';
import 'package:my_app/ui/user/form_user/form_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final CreateUserUseCase _createUserUseCase;
  final DepartmentListUseCase _departmentListUseCase;

  CreateUserBloc(this._createUserUseCase, this._departmentListUseCase)
    : super(CreateUserInitial()) {
    on<SubmitCreateUser>(_onSubmitCreateUser);
    on<GetRoleList>(_onGetRoleList);
  }

  Future<void> _onSubmitCreateUser(
    SubmitCreateUser event,
    Emitter<CreateUserState> emit,
  ) async {
    emit(CreateUserRoleLoading());
    try {
      final response = await _createUserUseCase.call(event.params);
      if (response.success) {
        emit(CreateUserSubmitSuccess(response.message));
      } else {
        emit(CreateUserError(response.message));
      }
    } catch (e) {
      emit(CreateUserError("Lỗi hệ thống: ${e.toString()}"));
    }
  }

  Future<void> _onGetRoleList(
    GetRoleList event,
    Emitter<CreateUserState> emit,
  ) async {
    emit(CreateUserRoleLoading());
    try {
      final roles = await _createUserUseCase.getRoleList({});
      final departments = await _departmentListUseCase.callResources();
      emit(CreateUserFormReady(roles: roles, departments: departments));
    } catch (e) {
      emit(CreateUserError("Lỗi hệ thống: ${e.toString()}"));
    }
  }
}
