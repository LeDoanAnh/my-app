import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/submission_step.dart';

part 'submission_step_model.g.dart';

@JsonSerializable()
class SubmissionStepModel {
  final int id;
  final String? code;
  final String? title;
  final String? content;
  final String? status;
  @JsonKey(name: 'current_step')
  final int? currentStep;
  @JsonKey(name: 'total_steps')
  final int? totalSteps;
  @JsonKey(name: 'logs')
  final List<DepartmentStepModel>? departmentSteps;
  @JsonKey(name: 'last_dept_name')
  final String? lastDeptName;

  SubmissionStepModel({
    required this.id,
    this.code,
    this.title,
    this.content,
    this.status,
    this.currentStep,
    this.totalSteps,
    this.departmentSteps,
    this.lastDeptName
  });

  factory SubmissionStepModel.fromJson(Map<String, dynamic> json) => _$SubmissionStepModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionStepModelToJson(this);

  SubmissionStep toEntity() {
    return SubmissionStep(
      id: id,
      code: code,
      title: title,
      status: status,
      currentStep: currentStep,
      content: content,
      totalSteps: totalSteps,
      departmentSteps: departmentSteps?.map((step) => step.toEntity()).toList(),
      lastDeptName: lastDeptName,
    );
  }
}

@JsonSerializable()
class DepartmentStepModel{
  @JsonKey(name: 'dept_name')
  final String? deptName;
  final String? status;
  final String? time;
  final String? comment;
  @JsonKey(name: 'request_content')
  final String? requestContent;

  DepartmentStepModel({this.deptName, this.status, this.time, this.comment, this.requestContent});

  factory DepartmentStepModel.fromJson(Map<String, dynamic> json) => _$DepartmentStepModelFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentStepModelToJson(this);

  DepartmentStep toEntity() {
    return DepartmentStep(
      deptName: deptName,
      status: status,
      time: time,
      comment: comment,
      requestContent: requestContent,
    );
  }
}
