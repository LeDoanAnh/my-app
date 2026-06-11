import 'package:my_app/domain/entities/approval_step_entity.dart';
import 'package:my_app/domain/entities/department_entity.dart';

abstract class CreateWorkflowState {}

class CreateWorkflowInitial extends CreateWorkflowState {}

class CreateWorkflowLoading extends CreateWorkflowState {}

class CreateWorkflowReady extends CreateWorkflowState {
  final List<DepartmentEntity> departments;
  final ApprovalStepEntity? workflow;

  CreateWorkflowReady({required this.departments, this.workflow});
}

class CreateWorkflowSaving extends CreateWorkflowState {}

class CreateWorkflowSuccess extends CreateWorkflowState {
  final String message;

  CreateWorkflowSuccess(this.message);
}

class CreateWorkflowError extends CreateWorkflowState {
  final String message;

  CreateWorkflowError(this.message);
}
