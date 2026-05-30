import 'package:my_app/domain/entities/department_entity.dart';

abstract class DepartmentDetailState {}

class DepartmentDetailInitial extends DepartmentDetailState {}

class DepartmentDetailLoading extends DepartmentDetailState {}

class DepartmentDetailLoaded extends DepartmentDetailState {
  final DepartmentEntity department;
  DepartmentDetailLoaded(this.department);
}

class DepartmentDetailError extends DepartmentDetailState {
  final String message;
  DepartmentDetailError(this.message);
}
