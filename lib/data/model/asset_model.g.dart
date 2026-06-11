// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => AssetModel(
  id: (json['id'] as num).toInt(),
  departmentId: (json['department_id'] as num?)?.toInt(),
  assetName: json['asset_name'] as String?,
  assetCode: json['asset_code'] as String?,
  unit: json['unit'] as String?,
  type: json['type'] as String?,
  status: json['status'] as String?,
  totalQuantity: (json['total_quantity'] as num?)?.toInt(),
  borrowedQuantity: (json['borrowed_quantity'] as num?)?.toInt(),
  pendingQuantity: (json['pending_quantity'] as num?)?.toInt(),
  availableQuantity: (json['available_quantity'] as num?)?.toInt(),
  department: json['department'] == null
      ? null
      : DepartmentModel.fromJson(json['department'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssetModelToJson(AssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'department_id': instance.departmentId,
      'asset_name': instance.assetName,
      'asset_code': instance.assetCode,
      'unit': instance.unit,
      'type': instance.type,
      'status': instance.status,
      'total_quantity': instance.totalQuantity,
      'borrowed_quantity': instance.borrowedQuantity,
      'pending_quantity': instance.pendingQuantity,
      'available_quantity': instance.availableQuantity,
      'department': instance.department,
    };

AssetResponseModel _$AssetResponseModelFromJson(Map<String, dynamic> json) =>
    AssetResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetResponseModelToJson(AssetResponseModel instance) =>
    <String, dynamic>{'data': instance.data};
