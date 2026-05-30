import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/submission_entity.dart';

part 'submission_model.g.dart';

@JsonSerializable()
class SubmissionModel {
  final int? id;
  final String? title;
  @JsonKey(name: 'submission_code')
  final String? submissionCode;
  final String? date;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  final String? status;
  @JsonKey(name: 'status_code')
  final String? statusCode;
  final String? time;
  @JsonKey(name: 'creator_name')
  final String? creatorName;
  @JsonKey(name: 'approver_name')
  final String? approverName;

  SubmissionModel({
    this.id,
    this.title,
    this.status,
    this.statusCode,
    this.statusLabel,
    this.time,
    this.creatorName,
    this.approverName,
    this.date,
    this.categoryName,
    this.submissionCode});

  factory SubmissionModel.fromJson(Map<String, dynamic> json) => _$SubmissionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionModelToJson(this);

  SubmissionEntity toEntity() => SubmissionEntity(
    id: id ?? 0,
    submissionCode: submissionCode ?? 'Không xác định',
    title: title ?? 'Không tiêu đề',
    date: date ?? DateTime.now().toString(),
    categoryName: categoryName ?? 'Không xác định',
    creatorName: creatorName ?? 'Không xác định',
    approverName: approverName ?? 'Không xác định',
    status: status ?? 'unknown',
    statusLabel: statusLabel ?? 'Không xác định',
    statusCode: statusCode ?? 'unknown',
    time: time ?? '',
  );
}

@JsonSerializable()
class SubmissionResponseModel {
  final List<SubmissionModel>? data;

  SubmissionResponseModel({this.data});

  factory SubmissionResponseModel.fromJson(Map<String, dynamic> json) => _$SubmissionResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionResponseModelToJson(this);


}