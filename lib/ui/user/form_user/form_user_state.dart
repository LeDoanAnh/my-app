import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/domain/entities/role_entity.dart';

abstract class CreateUserState {}

class CreateUserInitial extends CreateUserState {}

class CreateUserRoleLoading extends CreateUserState {}

class CreateUserFormReady extends CreateUserState {
  final List<RoleEntity> roles;
  final List<DepartmentEntity> departments;

  CreateUserFormReady({required this.roles, required this.departments});
}

class CreateUserSubmitLoading extends CreateUserState {
  final List<RoleEntity> roles;
  final List<DepartmentEntity> departments;

  CreateUserSubmitLoading({required this.roles, required this.departments});
}

class CreateUserSubmitSuccess extends CreateUserState {
  final String message;
  CreateUserSubmitSuccess(this.message);
}

class CreateUserError extends CreateUserState {
  final String message;
  CreateUserError(this.message);
}
