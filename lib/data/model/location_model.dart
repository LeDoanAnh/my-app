import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/location_entity.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  final int id;
  @JsonKey(name: "department_id")
  final int? departmentId;
  @JsonKey(name: "location_name")
  final String? locationName;
  final String? status;
  final String? capacity;

  final DepartmentModel? department;

  LocationModel({
    required this.id,
    this.departmentId,
    this.locationName,
    this.status,
    this.capacity,
    this.department,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  LocationEntity toEntity() {
    return LocationEntity(
      id: id,
      departmentId: departmentId,
      locationName: locationName,
      status: status,
      capacity: capacity,
      department: department?.toEntity(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LocationResponseModel {
  final List<LocationModel>? data;

  LocationResponseModel({required this.data});

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationResponseModelToJson(this);
}

@JsonSerializable()
class LocationParam {
  final String name;
  final String capacity;
  final String address;
  @JsonKey(name: "dept_id")
  final int deptId;

  LocationParam({
    required this.name,
    required this.capacity,
    required this.address,
    required this.deptId,
  });

  factory LocationParam.fromJson(Map<String, dynamic> json) =>
      _$LocationParamFromJson(json);
  Map<String, dynamic> toJson() => _$LocationParamToJson(this);
}
