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
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  @JsonKey(name: 'note_for_dept')
  final String? noteForDept;
  final List<ApproverLocationModel>? locations;
  final List<ApproverAssetModel>? assets;
  final List<ApproverAttachmentModel>? attachments;
  @JsonKey(name: 'previous_approvals')
  final List<PreviousApprovalModel>? previousApprovals;
  @JsonKey(name: 'pre_approval')
  final PreApprovalModel? preApproval;
  @JsonKey(name: 'is_pre_approved')
  final bool? isPreApproved;
  @JsonKey(name: 'my_decision')
  final MyDecisionModel? myDecision;

  ApproverSubmissionModel({
    required this.id,
    this.title,
    this.content,
    this.status,
    this.sender,
    this.startTime,
    this.endTime,
    this.noteForDept,
    this.locations,
    this.assets,
    this.attachments,
    this.previousApprovals,
    this.preApproval,
    this.isPreApproved,
    this.myDecision,
  });

  factory ApproverSubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverSubmissionModelFromJson(json);
}

@JsonSerializable()
class ApproverLocationModel {
  @JsonKey(name: 'location_name')
  final String? locationName;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;

  ApproverLocationModel({this.locationName, this.startTime, this.endTime});
  factory ApproverLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverLocationModelFromJson(json);
}

@JsonSerializable()
class ApproverAssetModel {
  @JsonKey(name: 'asset_name')
  final String? assetName;
  final int? quantity;

  ApproverAssetModel({this.assetName, this.quantity});
  factory ApproverAssetModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverAssetModelFromJson(json);
}

@JsonSerializable()
class ApproverAttachmentModel {
  @JsonKey(name: 'file_name')
  final String? fileName;
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @JsonKey(name: 'file_type')
  final String? fileType;
  @JsonKey(name: 'file_path')
  final String? filePath;
  final String? url;

  ApproverAttachmentModel({
    this.fileName,
    this.fileSize,
    this.fileType,
    this.filePath,
    this.url,
  });

  factory ApproverAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApproverAttachmentModelFromJson(json);
}

@JsonSerializable()
class PreviousApprovalModel {
  @JsonKey(name: 'step_id')
  final int? stepId;
  @JsonKey(name: 'step_order')
  final int? stepOrder;
  @JsonKey(name: 'dept_id')
  final int? deptId;
  @JsonKey(name: 'dept_name')
  final String? deptName;
  final String? action;
  final String? comment;
  @JsonKey(name: 'decided_at')
  final String? decidedAt;
  @JsonKey(name: 'approver_id')
  final int? approverId;
  @JsonKey(name: 'approver_name')
  final String? approverName;
  @JsonKey(name: 'approver_dept')
  final String? approverDept;

  PreviousApprovalModel({
    this.stepId,
    this.stepOrder,
    this.deptId,
    this.deptName,
    this.action,
    this.comment,
    this.decidedAt,
    this.approverId,
    this.approverName,
    this.approverDept,
  });

  factory PreviousApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousApprovalModelFromJson(json);
}

@JsonSerializable()
class MyDecisionModel {
  final String? action;
  final String? comment;
  @JsonKey(name: 'decided_at')
  final String? decidedAt;

  MyDecisionModel({this.action, this.comment, this.decidedAt});
  factory MyDecisionModel.fromJson(Map<String, dynamic> json) =>
      _$MyDecisionModelFromJson(json);
}

@JsonSerializable()
class PreApprovalModel {
  final int? id;
  final String? action;
  final String? comment;
  @JsonKey(name: 'decided_at')
  final String? decidedAt;
  @JsonKey(name: 'staff_id')
  final int? staffId;
  @JsonKey(name: 'staff_name')
  final String? staffName;
  @JsonKey(name: 'staff_dept')
  final String? staffDept;
  final List<ApproverAttachmentModel>? attachments;

  PreApprovalModel({
    this.id,
    this.action,
    this.comment,
    this.decidedAt,
    this.staffId,
    this.staffName,
    this.staffDept,
    this.attachments,
  });

  factory PreApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalModelFromJson(json);
}

@JsonSerializable()
class ApproverSubmissionResponse {
  final bool success;
  final ApproverSubmissionModel? data;

  ApproverSubmissionResponse({required this.success, this.data});
  factory ApproverSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApproverSubmissionResponseFromJson(json);
}
