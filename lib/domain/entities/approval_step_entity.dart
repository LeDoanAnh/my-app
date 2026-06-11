class ApprovalStepEntity {
  final int? id;
  final String? categoryName;
  final String? description;
  final int? applyForDeptId;
  final String? applyForDept;
  final String? status;
  final List<ApprovalStep>? approvalSteps;

  ApprovalStepEntity({
    required this.id,
    this.categoryName,
    this.description,
    this.applyForDeptId,
    this.applyForDept,
    this.status,
    this.approvalSteps,
  });

  @override
  String toString() {
    return 'ApprovalStepEntity{id: $id, categoryName: $categoryName, description: $description, applyForDeptId: $applyForDeptId, applyForDept: $applyForDept, status: $status, approvalSteps: $approvalSteps}';
  }
}

class ApprovalStep {
  final String? role;
  final String? desc;
  final int? stepOrder;
  final int? deptId;
  final int? targetRoleId;
  final String? targetDeptName;

  ApprovalStep({
    this.role,
    this.desc,
    this.stepOrder,
    this.deptId,
    this.targetRoleId,
    this.targetDeptName,
  });
  @override
  String toString() {
    return 'ApprovalStep{role: $role, desc: $desc, stepOrder: $stepOrder, deptId: $deptId, targetRoleId: $targetRoleId, targetDeptName: $targetDeptName}';
  }
}
