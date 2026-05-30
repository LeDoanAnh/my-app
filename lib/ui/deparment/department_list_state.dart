import 'package:my_app/domain/entities/department_entity.dart';

abstract class DepartmentListState {}

class DepartmentListInitial extends DepartmentListState {}

class DepartmentListLoading extends DepartmentListState {}

class DepartmentListLoaded extends DepartmentListState {
  final List<DepartmentEntity> departments;
  DepartmentListLoaded(this.departments);
}

class DepartmentListError extends DepartmentListState {
  final String message;
  DepartmentListError(this.message);
}
