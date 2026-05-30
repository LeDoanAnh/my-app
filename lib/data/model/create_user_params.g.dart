// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserParams _$CreateUserParamsFromJson(Map<String, dynamic> json) =>
    CreateUserParams(
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      departmentId: (json['department_id'] as num).toInt(),
      roleIds: (json['role_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$CreateUserParamsToJson(CreateUserParams instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'department_id': instance.departmentId,
      'role_ids': instance.roleIds,
      'status': instance.status,
    };
