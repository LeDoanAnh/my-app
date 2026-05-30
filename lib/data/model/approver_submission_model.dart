// data/model/approver_submission_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'approver_submission_model.g.dart';

@JsonSerializable()
class ApproverSubmissionModel {
  final int? id;
  final String? title;
  final String? content;
  final String? status;
  final String? sender;
  @JsonKey(name: 'start_time') final String? startTime;
  @JsonKey(name: 'end_time') final String? endTime;
  @JsonKey(name: 'note_for_dept') final String? noteForDept;
  final List<ApproverLocationModel>? locations;
  final List<ApproverAssetModel>? assets;
  @JsonKey(name: 'my_decision') final MyDecisionModel? myDecision;

  ApproverSubmissionModel({
    required this.id, this.title, this.content, this.status,
    this.sender, this.startTime, this.endTime, this.noteForDept,
    this.locations, this.assets, this.myDecision,
  });

  factory ApproverSubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverSubmissionModelFromJson(json);
}

@JsonSerializable()
class ApproverLocationModel {
  @JsonKey(name: 'location_name') final String? locationName;
  @JsonKey(name: 'start_time') final String? startTime;
  @JsonKey(name: 'end_time') final String? endTime;

  ApproverLocationModel({this.locationName, this.startTime, this.endTime});
  factory ApproverLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverLocationModelFromJson(json);
}

@JsonSerializable()
class ApproverAssetModel {
  @JsonKey(name: 'asset_name') final String? assetName;
  final int? quantity;

  ApproverAssetModel({this.assetName, this.quantity});
  factory ApproverAssetModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverAssetModelFromJson(json);
}

@JsonSerializable()
class MyDecisionModel {
  final String? action;
  final String? comment;
  @JsonKey(name: 'decided_at') final String? decidedAt;

  MyDecisionModel({this.action, this.comment, this.decidedAt});
  factory MyDecisionModel.fromJson(Map<String, dynamic> json) =>
      _$MyDecisionModelFromJson(json);
}

@JsonSerializable()
class ApproverSubmissionResponse {
  final bool success;
  final ApproverSubmissionModel? data;

  ApproverSubmissionResponse({required this.success, this.data});
  factory ApproverSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApproverSubmissionResponseFromJson(json);
}