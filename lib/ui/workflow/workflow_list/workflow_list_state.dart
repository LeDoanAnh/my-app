import 'package:my_app/domain/entities/workflow_list_entity.dart';

abstract class WorkflowListState {}

class WorkflowListInitial extends WorkflowListState {}

class WorkflowListLoading extends WorkflowListState {}

class WorkflowListLoaded extends WorkflowListState {
  final List<WorkflowListEntity> workflows;

  WorkflowListLoaded(this.workflows);
}

class WorkflowListError extends WorkflowListState {
  final String message;

  WorkflowListError(this.message);
}
