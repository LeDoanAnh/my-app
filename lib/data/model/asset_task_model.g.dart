// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTaskListResponse _$AssetTaskListResponseFromJson(
  Map<String, dynamic> json,
) => AssetTaskListResponse(
  success: json['success'] as bool,
  total: (json['total'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => AssetTaskModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AssetTaskListResponseToJson(
  AssetTaskListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'data': instance.data,
};

AssetTaskModel _$AssetTaskModelFromJson(Map<String, dynamic> json) =>
    AssetTaskModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      status: json['status'] as String?,
      date: json['date'] as String?,
      sender: json['sender'] as String?,
      itemCount: (json['item_count'] as num?)?.toInt(),
      approvedBy: json['approved_by'] == null
          ? null
          : ApprovedByModel.fromJson(
              json['approved_by'] as Map<String, dynamic>,
            ),
      assets: (json['assets'] as List<dynamic>?)
          ?.map((e) => AssetTaskItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetTaskModelToJson(AssetTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'date': instance.date,
      'sender': instance.sender,
      'item_count': instance.itemCount,
      'approved_by': instance.approvedBy,
      'assets': instance.assets,
    };

ApprovedByModel _$ApprovedByModelFromJson(Map<String, dynamic> json) =>
    ApprovedByModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      dept: json['dept'] as String?,
      action: json['action'] as String?,
      comment: json['comment'] as String?,
      approvedAt: json['approved_at'] as String?,
    );

Map<String, dynamic> _$ApprovedByModelToJson(ApprovedByModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dept': instance.dept,
      'action': instance.action,
      'comment': instance.comment,
      'approved_at': instance.approvedAt,
    };

AssetTaskItemModel _$AssetTaskItemModelFromJson(Map<String, dynamic> json) =>
    AssetTaskItemModel(
      assetId: (json['asset_id'] as num?)?.toInt(),
      assetName: json['asset_name'] as String?,
      assetCode: json['asset_code'] as String?,
      unit: json['unit'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      borrowDate: json['borrow_date'] as String?,
      expectedReturn: json['expected_return'] as String?,
      borrower: json['borrower'] == null
          ? null
          : AssetTaskBorrowerModel.fromJson(
              json['borrower'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AssetTaskItemModelToJson(AssetTaskItemModel instance) =>
    <String, dynamic>{
      'asset_id': instance.assetId,
      'asset_name': instance.assetName,
      'asset_code': instance.assetCode,
      'unit': instance.unit,
      'type': instance.type,
      'status': instance.status,
      'borrow_date': instance.borrowDate,
      'expected_return': instance.expectedReturn,
      'borrower': instance.borrower,
    };

AssetTaskBorrowerModel _$AssetTaskBorrowerModelFromJson(
  Map<String, dynamic> json,
) => AssetTaskBorrowerModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  dept: json['dept'] as String?,
);

Map<String, dynamic> _$AssetTaskBorrowerModelToJson(
  AssetTaskBorrowerModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dept': instance.dept,
};

AssetTaskDetailResponse _$AssetTaskDetailResponseFromJson(
  Map<String, dynamic> json,
) => AssetTaskDetailResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : AssetTaskDetailModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssetTaskDetailResponseToJson(
  AssetTaskDetailResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

AssetTaskDetailModel _$AssetTaskDetailModelFromJson(
  Map<String, dynamic> json,
) => AssetTaskDetailModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String?,
  status: json['status'] as String?,
  date: json['date'] as String?,
  sender: json['sender'] as String?,
  approvedBy: json['approved_by'] == null
      ? null
      : ApprovedByModel.fromJson(json['approved_by'] as Map<String, dynamic>),
  assets: (json['assets'] as List<dynamic>?)
      ?.map((e) => AssetTaskItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AssetTaskDetailModelToJson(
  AssetTaskDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': instance.status,
  'date': instance.date,
  'sender': instance.sender,
  'approved_by': instance.approvedBy,
  'assets': instance.assets,
};

HandoverResponse _$HandoverResponseFromJson(Map<String, dynamic> json) =>
    HandoverResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      allHandedOver: json['all_handed_over'] as bool?,
    );

Map<String, dynamic> _$HandoverResponseToJson(HandoverResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'all_handed_over': instance.allHandedOver,
    };
