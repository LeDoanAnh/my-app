abstract class CreateWorkflowEvent {}

class LoadCreateWorkflow extends CreateWorkflowEvent {
  final int? workflowId;

  LoadCreateWorkflow({this.workflowId});
}

class SubmitCreateWorkflow extends CreateWorkflowEvent {
  final int? workflowId;
  final Map<String, dynamic> body;

  SubmitCreateWorkflow({this.workflowId, required this.body});
}
