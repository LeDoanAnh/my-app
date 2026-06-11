// domain/entities/approver_submission_entity.dart
class ApproverSubmissionEntity {
  final int? id;
  final String? title;
  final String? content;
  final String? status;
  final String? sender;
  final String? startTime;
  final String? endTime;
  final String? noteForDept;
  final List<ApproverLocationEntity>? locations;
  final List<ApproverAssetEntity>? assets;
  final List<ApproverAttachmentEntity>? attachments;
  final List<PreviousApprovalEntity>? previousApprovals;
  final PreApprovalEntity? preApproval;
  final bool isPreApproved;
  final MyDecisionEntity? myDecision;

  ApproverSubmissionEntity({
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
    this.isPreApproved = false,
    this.myDecision,
  });
}

class ApproverLocationEntity {
  final String? locationName;
  final String? startTime;
  final String? endTime;
  ApproverLocationEntity({this.locationName, this.startTime, this.endTime});
}

class ApproverAssetEntity {
  final String? assetName;
  final int? quantity;
  ApproverAssetEntity({this.assetName, this.quantity});
}

class ApproverAttachmentEntity {
  final String? fileName;
  final int? fileSize;
  final String? fileType;
  final String? filePath;
  final String? url;

  ApproverAttachmentEntity({
    this.fileName,
    this.fileSize,
    this.fileType,
    this.filePath,
    this.url,
  });
}

class PreviousApprovalEntity {
  final int? stepId;
  final int? stepOrder;
  final int? deptId;
  final String? deptName;
  final String? action;
  final String? comment;
  final String? decidedAt;
  final int? approverId;
  final String? approverName;
  final String? approverDept;

  PreviousApprovalEntity({
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
}

class MyDecisionEntity {
  final String? action;
  final String? comment;
  final String? decidedAt;
  MyDecisionEntity({this.action, this.comment, this.decidedAt});
}

class PreApprovalEntity {
  final int? id;
  final String? action;
  final String? comment;
  final String? decidedAt;
  final int? staffId;
  final String? staffName;
  final String? staffDept;
  final List<ApproverAttachmentEntity>? attachments;

  PreApprovalEntity({
    this.id,
    this.action,
    this.comment,
    this.decidedAt,
    this.staffId,
    this.staffName,
    this.staffDept,
    this.attachments,
  });
}
