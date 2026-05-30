// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
  id: (json['id'] as num).toInt(),
  roleName: json['role_name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$RoleModelToJson(RoleModel instance) => <String, dynamic>{
  'id': instance.id,
  'role_name': instance.roleName,
  'description': instance.description,
};

RoleResponseModel _$RoleResponseModelFromJson(Map<String, dynamic> json) =>
    RoleResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoleResponseModelToJson(RoleResponseModel instance) =>
    <String, dynamic>{'data': instance.data};
