import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/entities/department_entity.dart';

part 'asset_model.g.dart';

@JsonSerializable()
class AssetModel {
  final int id;
  @JsonKey(name: "department_id")
  final int? departmentId;
  @JsonKey(name: "asset_name")
  final String? assetName;
  @JsonKey(name: "asset_code")
  final String? assetCode;
  final String? unit;
  final String? status;
  final DepartmentModel? department;

  AssetModel({
    required this.id,
    this.departmentId,
    this.assetName,
    this.assetCode,
    this.unit,
    this.status,
    this.department,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetModelToJson(this);

  AssetEntity toEntity() {
    return AssetEntity(
      id: id,
      departmentId: departmentId,
      assetName: assetName,
      assetCode: assetCode,
      unit: unit,
      status: status,
      department: department?.toEntity(),
    );
  }
}

@JsonSerializable()
class AssetResponseModel {
  final List<AssetModel>? data;

  AssetResponseModel({required this.data});

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetResponseModelToJson(this);
}
