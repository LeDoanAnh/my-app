// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      id: (json['id'] as num?)?.toInt(),
      deptName: json['dept_name'] as String?,
      locationDesc: json['location_desc'] as String?,
      status: json['status'] as String?,
      parentDeptId: (json['parent_dept_id'] as num?)?.toInt(),
      assets: (json['assets'] as List<dynamic>?)
          ?.map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      usersCount: (json['users_count'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetsCount: (json['assets_count'] as num?)?.toInt(),
      submissionsCount: (json['submissions_count'] as num?)?.toInt(),
      parent: json['parent'] == null
          ? null
          : DepartmentModel.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dept_name': instance.deptName,
      'location_desc': instance.locationDesc,
      'status': instance.status,
      'parent_dept_id': instance.parentDeptId,
      'users_count': instance.usersCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'assets_count': instance.assetsCount,
      'submissions_count': instance.submissionsCount,
      'parent': instance.parent,
      'assets': instance.assets,
      'locations': instance.locations,
      'users': instance.users,
    };

DepartmentResponseModel _$DepartmentResponseModelFromJson(
  Map<String, dynamic> json,
) => DepartmentResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DepartmentResponseModelToJson(
  DepartmentResponseModel instance,
) => <String, dynamic>{'data': instance.data};

DepartmentDetailResponseModel _$DepartmentDetailResponseModelFromJson(
  Map<String, dynamic> json,
) => DepartmentDetailResponseModel(
  data: json['data'] == null
      ? null
      : DepartmentModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DepartmentDetailResponseModelToJson(
  DepartmentDetailResponseModel instance,
) => <String, dynamic>{'data': instance.data};

CreateDepartmentResponse _$CreateDepartmentResponseFromJson(
  Map<String, dynamic> json,
) => CreateDepartmentResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateDepartmentResponseToJson(
  CreateDepartmentResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
