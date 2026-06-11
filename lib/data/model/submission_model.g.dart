// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionModel _$SubmissionModelFromJson(Map<String, dynamic> json) =>
    SubmissionModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      status: json['status'] as String?,
      statusCode: json['status_code'] as String?,
      statusLabel: json['status_label'] as String?,
      time: json['time'] as String?,
      creatorName: json['creator_name'] as String?,
      approverName: json['approver_name'] as String?,
      preApprovalStatus: json['pre_approval_status'] as String?,
      preApproverName: json['pre_approver_name'] as String?,
      date: json['date'] as String?,
      categoryName: json['category_name'] as String?,
      submissionCode: json['submission_code'] as String?,
    );

Map<String, dynamic> _$SubmissionModelToJson(SubmissionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'submission_code': instance.submissionCode,
      'date': instance.date,
      'category_name': instance.categoryName,
      'status_label': instance.statusLabel,
      'status': instance.status,
      'status_code': instance.statusCode,
      'time': instance.time,
      'creator_name': instance.creatorName,
      'approver_name': instance.approverName,
      'pre_approval_status': instance.preApprovalStatus,
      'pre_approver_name': instance.preApproverName,
    };

SubmissionResponseModel _$SubmissionResponseModelFromJson(
  Map<String, dynamic> json,
) => SubmissionResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubmissionResponseModelToJson(
  SubmissionResponseModel instance,
) => <String, dynamic>{'data': instance.data};
