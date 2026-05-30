abstract class WorkflowDetailEvent {}

class GetWorkflowDetailEvent extends WorkflowDetailEvent {
  final int id;

  GetWorkflowDetailEvent(this.id);
}
