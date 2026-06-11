import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/asset_entity.dart';

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
  final String? type;
  final String? status;
  @JsonKey(name: "total_quantity")
  final int? totalQuantity;
  @JsonKey(name: "borrowed_quantity")
  final int? borrowedQuantity;
  @JsonKey(name: "pending_quantity")
  final int? pendingQuantity;
  @JsonKey(name: "available_quantity")
  final int? availableQuantity;
  final DepartmentModel? department;

  AssetModel({
    required this.id,
    this.departmentId,
    this.assetName,
    this.assetCode,
    this.unit,
    this.type,
    this.status,
    this.totalQuantity,
    this.borrowedQuantity,
    this.pendingQuantity,
    this.availableQuantity,
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
      type: type,
      status: status,
      totalQuantity: totalQuantity,
      borrowedQuantity: borrowedQuantity,
      pendingQuantity: pendingQuantity,
      availableQuantity: availableQuantity,
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
