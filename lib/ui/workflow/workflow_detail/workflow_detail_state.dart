import 'package:my_app/domain/entities/approval_step_entity.dart';

abstract class WorkflowDetailState {}

class WorkDetailInitial extends WorkflowDetailState {}

class WorkDetailLoading extends WorkflowDetailState {}

class WorkDetailLoaded extends WorkflowDetailState {
  final ApprovalStepEntity approvalStep;

  WorkDetailLoaded(this.approvalStep);
}

class WorkDetailError extends WorkflowDetailState {
  final String message;

  WorkDetailError(this.message);
}
