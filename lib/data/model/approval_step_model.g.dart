// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalStepModel _$ApprovalStepModelFromJson(Map<String, dynamic> json) =>
    ApprovalStepModel(
      id: (json['id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      applyForDept: json['apply_for_dept'] as String?,
      approvalSteps: (json['approval_steps'] as List<dynamic>?)
          ?.map((e) => ApprovalStepDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApprovalStepModelToJson(ApprovalStepModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
      'apply_for_dept': instance.applyForDept,
      'approval_steps': instance.approvalSteps,
    };

ApprovalStepDetail _$ApprovalStepDetailFromJson(Map<String, dynamic> json) =>
    ApprovalStepDetail(
      role: json['role'] as String?,
      desc: json['desc'] as String?,
      stepOrder: (json['step_order'] as num?)?.toInt(),
      deptId: (json['dept_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApprovalStepDetailToJson(ApprovalStepDetail instance) =>
    <String, dynamic>{
      'role': instance.role,
      'desc': instance.desc,
      'step_order': instance.stepOrder,
      'dept_id': instance.deptId,
    };

WorkflowDetail _$WorkflowDetailFromJson(Map<String, dynamic> json) =>
    WorkflowDetail(
      data: ApprovalStepModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowDetailToJson(WorkflowDetail instance) =>
    <String, dynamic>{'data': instance.data};
