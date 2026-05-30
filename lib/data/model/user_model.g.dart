// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String?,
  fullName: json['full_name'] as String?,
  email: json['email'] as String?,
  sessionId: json['session_id'] as String?,
  token: json['token'] as String?,
  roles: (json['roles'] as List<dynamic>?)
      ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  departmentId: (json['department_id'] as num?)?.toInt(),
  status: json['status'] as String?,
  departmentName: json['department_name'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  totalSubmissions: (json['total_submissions'] as num?)?.toInt(),
  unreadNotifications: (json['unread_notifications'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'full_name': instance.fullName,
  'email': instance.email,
  'session_id': instance.sessionId,
  'token': instance.token,
  'roles': instance.roles,
  'department_id': instance.departmentId,
  'department_name': instance.departmentName,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'total_submissions': instance.totalSubmissions,
  'unread_notifications': instance.unreadNotifications,
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  data: json['data'] == null
      ? null
      : UserModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{'data': instance.data};
