import 'package:my_app/domain/entities/department_entity.dart';

abstract class FormResourceState {
  final List<DepartmentEntity> departments;
  FormResourceState({this.departments = const []});
}

class FormResourceInitial extends FormResourceState {}

class FormResourceLoading extends FormResourceState {
  FormResourceLoading({super.departments});
}

class FormResourceLoaded extends FormResourceState {
  FormResourceLoaded(List<DepartmentEntity> departments)
    : super(departments: departments);
}

class FormResourceError extends FormResourceState {
  final String message;
  FormResourceError(this.message, {super.departments});
}

class FormResourceSuccess extends FormResourceState {
  final String message;
  FormResourceSuccess(this.message, {super.departments});
}
