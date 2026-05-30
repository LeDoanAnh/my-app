import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/approval_step_entity.dart';

part 'approval_step_model.g.dart';

@JsonSerializable()
class ApprovalStepModel {
  final int? id;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'apply_for_dept')
  final String? applyForDept;
  @JsonKey(name: 'approval_steps')
  final List<ApprovalStepDetail>? approvalSteps;

  ApprovalStepModel({
    this.id,
    this.categoryName,
    this.applyForDept,
    this.approvalSteps,
  });
  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalStepModelToJson(this);

  ApprovalStepEntity toEntity() {
    return ApprovalStepEntity(
      id: id,
      categoryName: categoryName,
      applyForDept: applyForDept,
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

  ApprovalStepDetail({this.role, this.desc, this.stepOrder, this.deptId});

  factory ApprovalStepDetail.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStepDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalStepDetailToJson(this);

  ApprovalStep toEntity() {
    return ApprovalStep(
      role: role,
      desc: desc,
      stepOrder: stepOrder,
      deptId: deptId,
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
