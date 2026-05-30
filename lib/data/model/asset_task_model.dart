// data/model/asset_task_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'asset_task_model.g.dart';

@JsonSerializable()
class AssetTaskListResponse {
  final bool success;
  final int? total;
  final List<AssetTaskModel>? data;

  AssetTaskListResponse({required this.success, this.total, this.data});

  factory AssetTaskListResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskListResponseFromJson(json);
}

@JsonSerializable()
class AssetTaskModel {
  final int id;
  final String? title;
  final String? status;
  final String? date;
  final String? sender;
  @JsonKey(name: 'item_count') final int? itemCount;
  @JsonKey(name: 'approved_by') final ApprovedByModel? approvedBy;
  final List<AssetTaskItemModel>? assets;

  AssetTaskModel({
    required this.id, this.title, this.status, this.date,
    this.sender, this.itemCount, this.approvedBy, this.assets,
  });

  factory AssetTaskModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskModelFromJson(json);
}

@JsonSerializable()
class ApprovedByModel {
  final int? id;
  final String? name;
  final String? dept;
  final String? action;
  final String? comment;
  @JsonKey(name: 'approved_at') final String? approvedAt;

  ApprovedByModel({this.id, this.name, this.dept, this.action, this.comment, this.approvedAt});

  factory ApprovedByModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovedByModelFromJson(json);
}

@JsonSerializable()
class AssetTaskItemModel {
  @JsonKey(name: 'asset_id') final int? assetId;
  @JsonKey(name: 'asset_name') final String? assetName;
  @JsonKey(name: 'asset_code') final String? assetCode;
  final String? unit;
  final String? type;
  final String? status;
  @JsonKey(name: 'borrow_date') final String? borrowDate;
  @JsonKey(name: 'expected_return') final String? expectedReturn;
  final AssetTaskBorrowerModel? borrower;

  AssetTaskItemModel({
    this.assetId, this.assetName, this.assetCode, this.unit,
    this.type, this.status, this.borrowDate, this.expectedReturn, this.borrower,
  });

  factory AssetTaskItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskItemModelFromJson(json);
}

@JsonSerializable()
class AssetTaskBorrowerModel {
  final int? id;
  final String? name;
  final String? dept;

  AssetTaskBorrowerModel({this.id, this.name, this.dept});

  factory AssetTaskBorrowerModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskBorrowerModelFromJson(json);
}

// Thêm vào asset_task_model.dart

@JsonSerializable()
class AssetTaskDetailResponse {
  final bool success;
  final AssetTaskDetailModel? data;

  AssetTaskDetailResponse({required this.success, this.data});
  factory AssetTaskDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskDetailResponseFromJson(json);
}

@JsonSerializable()
class AssetTaskDetailModel {
  final int id;
  final String? title;
  final String? status;
  final String? date;
  final String? sender;
  @JsonKey(name: 'approved_by') final ApprovedByModel? approvedBy;
  final List<AssetTaskItemModel>? assets;

  AssetTaskDetailModel({
    required this.id, this.title, this.status,
    this.date, this.sender, this.approvedBy, this.assets,
  });
  factory AssetTaskDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTaskDetailModelFromJson(json);
}

@JsonSerializable()
class HandoverResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'all_handed_over') final bool? allHandedOver;

  HandoverResponse({required this.success, required this.message, this.allHandedOver});
  factory HandoverResponse.fromJson(Map<String, dynamic> json) =>
      _$HandoverResponseFromJson(json);
}