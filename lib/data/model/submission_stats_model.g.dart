// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionStatsModel _$SubmissionStatsModelFromJson(
  Map<String, dynamic> json,
) => SubmissionStatsModel(
  total: (json['total_submissions'] as num?)?.toInt(),
  pending: (json['pending_submissions'] as num?)?.toInt(),
  rejected: (json['rejected_submissions'] as num?)?.toInt(),
);

Map<String, dynamic> _$SubmissionStatsModelToJson(
  SubmissionStatsModel instance,
) => <String, dynamic>{
  'total_submissions': instance.total,
  'pending_submissions': instance.pending,
  'rejected_submissions': instance.rejected,
};
