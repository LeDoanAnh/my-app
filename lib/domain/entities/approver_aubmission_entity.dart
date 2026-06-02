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

class MyDecisionEntity {
  final String? action;
  final String? comment;
  final String? decidedAt;
  MyDecisionEntity({this.action, this.comment, this.decidedAt});
}
