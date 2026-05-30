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
  final MyDecisionEntity? myDecision;

  ApproverSubmissionEntity({
    required this.id, this.title, this.content, this.status,
    this.sender, this.startTime, this.endTime, this.noteForDept,
    this.locations, this.assets, this.myDecision,
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

class MyDecisionEntity {
  final String? action;
  final String? comment;
  final String? decidedAt;
  MyDecisionEntity({this.action, this.comment, this.decidedAt});
}