class ApprovalStepEntity {
  final int? id;
  final String? categoryName;
  final String? applyForDept;
  final List<ApprovalStep>? approvalSteps;

  ApprovalStepEntity({required this.id, this.categoryName, this.applyForDept, this.approvalSteps});

  @override
  String toString() {
    return 'ApprovalStepEntity{id: $id, categoryName: $categoryName, applyForDept: $applyForDept, approvalSteps: $approvalSteps}';
  }
}

class ApprovalStep{
  final String? role;
  final String? desc;
  final int? stepOrder;
  final int? deptId;

  ApprovalStep({this.role, this.desc, this.stepOrder, this.deptId});
  @override
  String toString() {
    return 'ApprovalStep{role: $role, desc: $desc, stepOrder: $stepOrder, deptId: $deptId}';
  }
}