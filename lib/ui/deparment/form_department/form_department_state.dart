import 'package:my_app/domain/entities/department_entity.dart';

abstract class FormDepartmentState {}

class FormDepartmentInitial extends FormDepartmentState {}

class FormDepartmentLoading extends FormDepartmentState {}

class FormDepartmentFormReady extends FormDepartmentState {
  final List<DepartmentEntity> departments;
  FormDepartmentFormReady(this.departments);
}

class FormDepartmentLoaded extends FormDepartmentState {
  final List<DepartmentEntity> departments;
  FormDepartmentLoaded(this.departments);
}

class FormDepartmentError extends FormDepartmentState {
  final String message;
  FormDepartmentError(this.message);
}

class FormDepartmentSuccess extends FormDepartmentState {
  final String message;
  FormDepartmentSuccess(this.message);
}
