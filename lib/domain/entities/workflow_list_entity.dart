class WorkflowListEntity {
  final int id;
  final String? name;
  final String? description;
  final String? applyTo;
  final int? stepsCount;
  final String? status;
  final List<String>? steps;

  WorkflowListEntity({
    required this.id,
    this.name,
    this.description,
    this.applyTo,
    this.stepsCount,
    this.status,
    this.steps,
  });
}
