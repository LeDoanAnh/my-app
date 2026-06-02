// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approver_submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApproverSubmissionModel _$ApproverSubmissionModelFromJson(
  Map<String, dynamic> json,
) => ApproverSubmissionModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  status: json['status'] as String?,
  sender: json['sender'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  noteForDept: json['note_for_dept'] as String?,
  locations: (json['locations'] as List<dynamic>?)
      ?.map((e) => ApproverLocationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  assets: (json['assets'] as List<dynamic>?)
      ?.map((e) => ApproverAssetModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => ApproverAttachmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  myDecision: json['my_decision'] == null
      ? null
      : MyDecisionModel.fromJson(json['my_decision'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApproverSubmissionModelToJson(
  ApproverSubmissionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'status': instance.status,
  'sender': instance.sender,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'note_for_dept': instance.noteForDept,
  'locations': instance.locations,
  'assets': instance.assets,
  'attachments': instance.attachments,
  'my_decision': instance.myDecision,
};

ApproverLocationModel _$ApproverLocationModelFromJson(
  Map<String, dynamic> json,
) => ApproverLocationModel(
  locationName: json['location_name'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
);

Map<String, dynamic> _$ApproverLocationModelToJson(
  ApproverLocationModel instance,
) => <String, dynamic>{
  'location_name': instance.locationName,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
};

ApproverAssetModel _$ApproverAssetModelFromJson(Map<String, dynamic> json) =>
    ApproverAssetModel(
      assetName: json['asset_name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApproverAssetModelToJson(ApproverAssetModel instance) =>
    <String, dynamic>{
      'asset_name': instance.assetName,
      'quantity': instance.quantity,
    };

ApproverAttachmentModel _$ApproverAttachmentModelFromJson(
  Map<String, dynamic> json,
) => ApproverAttachmentModel(
  fileName: json['file_name'] as String?,
  fileSize: (json['file_size'] as num?)?.toInt(),
  fileType: json['file_type'] as String?,
  filePath: json['file_path'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$ApproverAttachmentModelToJson(
  ApproverAttachmentModel instance,
) => <String, dynamic>{
  'file_name': instance.fileName,
  'file_size': instance.fileSize,
  'file_type': instance.fileType,
  'file_path': instance.filePath,
  'url': instance.url,
};

MyDecisionModel _$MyDecisionModelFromJson(Map<String, dynamic> json) =>
    MyDecisionModel(
      action: json['action'] as String?,
      comment: json['comment'] as String?,
      decidedAt: json['decided_at'] as String?,
    );

Map<String, dynamic> _$MyDecisionModelToJson(MyDecisionModel instance) =>
    <String, dynamic>{
      'action': instance.action,
      'comment': instance.comment,
      'decided_at': instance.decidedAt,
    };

ApproverSubmissionResponse _$ApproverSubmissionResponseFromJson(
  Map<String, dynamic> json,
) => ApproverSubmissionResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : ApproverSubmissionModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApproverSubmissionResponseToJson(
  ApproverSubmissionResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
