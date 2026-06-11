import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/asset_model.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  final int? id;
  @JsonKey(name: 'dept_name')
  final String? deptName;
  @JsonKey(name: 'location_desc')
  final String? locationDesc;
  final String? status;
  @JsonKey(name: 'parent_dept_id')
  final int? parentDeptId;
  @JsonKey(name: "users_count")
  final int? usersCount;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "assets_count")
  final int? assetsCount;
  @JsonKey(name: "submissions_count")
  final int? submissionsCount;
  final DepartmentModel? parent;
  final List<AssetModel>? assets;
  final List<LocationModel>? locations;
  final List<UserModel>? users;

  DepartmentModel({
    this.id,
    this.deptName,
    this.locationDesc,
    this.status,
    this.parentDeptId,
    this.assets,
    this.locations,
    this.usersCount,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.assetsCount,
    this.submissionsCount,
    this.parent,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);

  DepartmentEntity toEntity() {
    return DepartmentEntity(
      id: id ?? 1,
      deptName: deptName,
      locationDesc: locationDesc,
      status: status,
      parentDeptId: parentDeptId,
      usersCount: usersCount,
      assets: assets,
      locations: locations,
      users: users,
      assetsCount: assetsCount,
      submissionsCount: submissionsCount,
      parent: parent,
    );
  }

  @override
  String toString() {
    return 'DepartmentModel{id: $id, deptName: $deptName, locationDesc: $locationDesc, status: $status, parentDeptId: $parentDeptId, usersCount: $usersCount, createdAt: $createdAt, updatedAt: $updatedAt, assetsCount: $assetsCount, submissionsCount: $submissionsCount, parent: $parent, assets: $assets, locations: $locations, users: $users}';
  }
}

@JsonSerializable()
class DepartmentResponseModel {
  final List<DepartmentModel>? data;

  DepartmentResponseModel({this.data});

  factory DepartmentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentResponseModelToJson(this);
}

@JsonSerializable()
class DepartmentDetailResponseModel {
  final DepartmentModel? data;
  DepartmentDetailResponseModel({this.data});

  factory DepartmentDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentDetailResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentDetailResponseModelToJson(this);
}

@JsonSerializable()
class CreateDepartmentResponse {
  final bool success;
  final String message;

  CreateDepartmentResponse({required this.success, required this.message});
  factory CreateDepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDepartmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDepartmentResponseToJson(this);
}
