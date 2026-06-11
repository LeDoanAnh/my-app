import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/approval_step_entity.dart';

part 'approval_step_model.g.dart';

@JsonSerializable()
class ApprovalStepModel {
  final int? id;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  final String? description;
  @JsonKey(name: 'apply_for_dept_id')
  final int? applyForDeptId;
  @JsonKey(name: 'apply_for_dept')
  final String? applyForDept;
  final String? status;
  @JsonKey(name: 'approval_steps')
  final List<ApprovalStepDetail>? approvalSteps;

  ApprovalStepModel({
    this.id,
    this.categoryName,
    this.description,
    this.applyForDeptId,
    this.applyForDept,
    this.status,
    this.approvalSteps,
  });
  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalStepModelToJson(this);

  ApprovalStepEntity toEntity() {
    return ApprovalStepEntity(
      id: id,
      categoryName: categoryName,
      description: description,
      applyForDeptId: applyForDeptId,
      applyForDept: applyForDept,
      status: status,
      approvalSteps: approvalSteps?.map((step) => step.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class ApprovalStepDetail {
  final String? role;
  final String? desc;
  @JsonKey(name: 'step_order')
  final int? stepOrder;
  @JsonKey(name: 'dept_id')
  final int? deptId;
  @JsonKey(name: 'target_role_id')
  final int? targetRoleId;
  @JsonKey(name: 'target_dept_name')
  final String? targetDeptName;

  ApprovalStepDetail({
    this.role,
    this.desc,
    this.stepOrder,
    this.deptId,
    this.targetRoleId,
    this.targetDeptName,
  });

  factory ApprovalStepDetail.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStepDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalStepDetailToJson(this);

  ApprovalStep toEntity() {
    return ApprovalStep(
      role: role,
      desc: desc,
      stepOrder: stepOrder,
      deptId: deptId,
      targetRoleId: targetRoleId,
      targetDeptName: targetDeptName,
    );
  }
}

@JsonSerializable()
class WorkflowDetail {
  final ApprovalStepModel data;
  WorkflowDetail({required this.data});

  factory WorkflowDetail.fromJson(Map<String, dynamic> json) =>
      _$WorkflowDetailFromJson(json);
  Map<String, dynamic> toJson() => _$WorkflowDetailToJson(this);
}
