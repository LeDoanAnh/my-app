// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: (json['id'] as num).toInt(),
      departmentId: (json['department_id'] as num?)?.toInt(),
      locationName: json['location_name'] as String?,
      status: json['status'] as String?,
      availabilityStatus: json['availability_status'] as String?,
      conflictStatus: json['conflict_status'] as String?,
      conflictMessage: json['conflict_message'] as String?,
      capacity: json['capacity'] as String?,
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'department_id': instance.departmentId,
      'location_name': instance.locationName,
      'status': instance.status,
      'availability_status': instance.availabilityStatus,
      'conflict_status': instance.conflictStatus,
      'conflict_message': instance.conflictMessage,
      'capacity': instance.capacity,
      'department': instance.department,
    };

LocationResponseModel _$LocationResponseModelFromJson(
  Map<String, dynamic> json,
) => LocationResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LocationResponseModelToJson(
  LocationResponseModel instance,
) => <String, dynamic>{'data': instance.data?.map((e) => e.toJson()).toList()};

LocationParam _$LocationParamFromJson(Map<String, dynamic> json) =>
    LocationParam(
      name: json['name'] as String,
      capacity: json['capacity'] as String,
      address: json['address'] as String,
      deptId: (json['dept_id'] as num).toInt(),
    );

Map<String, dynamic> _$LocationParamToJson(LocationParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capacity': instance.capacity,
      'address': instance.address,
      'dept_id': instance.deptId,
    };
