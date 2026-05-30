// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionStepModel _$SubmissionStepModelFromJson(Map<String, dynamic> json) =>
    SubmissionStepModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?,
      currentStep: (json['current_step'] as num?)?.toInt(),
      totalSteps: (json['total_steps'] as num?)?.toInt(),
      departmentSteps: (json['logs'] as List<dynamic>?)
          ?.map((e) => DepartmentStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastDeptName: json['last_dept_name'] as String?,
    );

Map<String, dynamic> _$SubmissionStepModelToJson(
  SubmissionStepModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'title': instance.title,
  'content': instance.content,
  'status': instance.status,
  'current_step': instance.currentStep,
  'total_steps': instance.totalSteps,
  'logs': instance.departmentSteps,
  'last_dept_name': instance.lastDeptName,
};

DepartmentStepModel _$DepartmentStepModelFromJson(Map<String, dynamic> json) =>
    DepartmentStepModel(
      deptName: json['dept_name'] as String?,
      status: json['status'] as String?,
      time: json['time'] as String?,
      comment: json['comment'] as String?,
      requestContent: json['request_content'] as String?,
    );

Map<String, dynamic> _$DepartmentStepModelToJson(
  DepartmentStepModel instance,
) => <String, dynamic>{
  'dept_name': instance.deptName,
  'status': instance.status,
  'time': instance.time,
  'comment': instance.comment,
  'request_content': instance.requestContent,
};
