// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubmissionResponse _$CreateSubmissionResponseFromJson(
  Map<String, dynamic> json,
) => CreateSubmissionResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  submissionId: (json['submission_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateSubmissionResponseToJson(
  CreateSubmissionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'submission_id': instance.submissionId,
};
