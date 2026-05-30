// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDetailModel _$AssetDetailModelFromJson(Map<String, dynamic> json) =>
    AssetDetailModel(
      id: (json['id'] as num).toInt(),
      assetName: json['asset_name'] as String?,
      assetCode: json['asset_code'] as String?,
      unit: json['unit'] as String?,
      status: json['status'] as String?,
      deptName: json['dept_name'] as String?,
      isConsumable: json['is_consumable'] as bool?,
      currentRequest: json['current_request'] == null
          ? null
          : CurrentRequestModel.fromJson(
              json['current_request'] as Map<String, dynamic>,
            ),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetDetailModelToJson(AssetDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'asset_name': instance.assetName,
      'asset_code': instance.assetCode,
      'unit': instance.unit,
      'status': instance.status,
      'dept_name': instance.deptName,
      'is_consumable': instance.isConsumable,
      'current_request': instance.currentRequest,
      'history': instance.history,
    };

CurrentRequestModel _$CurrentRequestModelFromJson(Map<String, dynamic> json) =>
    CurrentRequestModel(
      borrower: json['borrower'] as String?,
      handler: json['handler'] as String?,
      borrowDate: json['borrow_date'] as String?,
      expectedReturn: json['expected_return'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CurrentRequestModelToJson(
  CurrentRequestModel instance,
) => <String, dynamic>{
  'borrower': instance.borrower,
  'handler': instance.handler,
  'borrow_date': instance.borrowDate,
  'expected_return': instance.expectedReturn,
  'note': instance.note,
};

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
  user: json['user'] as String?,
  action: json['action'] as String?,
  date: json['date'] as String?,
);

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'action': instance.action,
      'date': instance.date,
    };

AssetParam _$AssetParamFromJson(Map<String, dynamic> json) => AssetParam(
  name: json['name'] as String,
  description: json['description'] as String,
  unit: json['unit'] as String,
  assetType: json['asset_type'] as String,
  deptId: (json['deptId'] as num).toInt(),
);

Map<String, dynamic> _$AssetParamToJson(AssetParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'unit': instance.unit,
      'asset_type': instance.assetType,
      'deptId': instance.deptId,
    };
