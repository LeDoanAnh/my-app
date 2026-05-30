import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';

part 'submission_stats_model.g.dart';

@JsonSerializable()
class SubmissionStatsModel {
  @JsonKey(name: 'total_submissions')
  final int? total;

  @JsonKey(name: 'pending_submissions')
  final int? pending;

  @JsonKey(name: 'rejected_submissions')
  final int? rejected;

  SubmissionStatsModel({this.total, this.pending, this.rejected});

  factory SubmissionStatsModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionStatsModelToJson(this);

  SubmissionStatsEntity toEntity() {
    return SubmissionStatsEntity(
      total: total ?? 0,
      pending: pending ?? 0,
      rejected: rejected ?? 0,
    );
  }
}
