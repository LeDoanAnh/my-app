// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorModel _$ActorModelFromJson(Map<String, dynamic> json) => ActorModel(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String?,
  status: json['status'] as String?,
  department: json['department'] == null
      ? null
      : DepartmentModel.fromJson(json['department'] as Map<String, dynamic>),
  actorId: (json['actor_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActorModelToJson(ActorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actor_id': instance.actorId,
      'full_name': instance.fullName,
      'status': instance.status,
      'department': instance.department,
    };

ActorResponseModel _$ActorResponseModelFromJson(Map<String, dynamic> json) =>
    ActorResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ActorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActorResponseModelToJson(ActorResponseModel instance) =>
    <String, dynamic>{'data': instance.data};
