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
  status: json['status'] as String?,
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
      'status': instance.status,
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
