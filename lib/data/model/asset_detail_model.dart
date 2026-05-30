import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/asset_detail_entity.dart';

part 'asset_detail_model.g.dart';

@JsonSerializable()
class AssetDetailModel {
  final int id;
  @JsonKey(name: 'asset_name')
  final String? assetName;
  @JsonKey(name: 'asset_code')
  final String? assetCode;
  final String? unit;
  final String? status;
  @JsonKey(name: 'dept_name')
  final String? deptName;
  @JsonKey(name: 'is_consumable')
  final bool? isConsumable;
  @JsonKey(name: 'current_request')
  final CurrentRequestModel? currentRequest;
  final List<HistoryModel>? history;

  AssetDetailModel({
    required this.id,
    this.assetName,
    this.assetCode,
    this.unit,
    this.status,
    this.deptName,
    this.isConsumable,
    this.currentRequest,
    this.history,
  });

  factory AssetDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AssetDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetDetailModelToJson(this);

  @override
  String toString() {
    return 'AssetDetailEntity(id: $id, assetName: $assetName, assetCode: $assetCode, unit: $unit, status: $status, deptName: $deptName, isConsumable: $isConsumable, currentRequest: $currentRequest, history: $history)';
  }

  AssetDetailEntity toEntity() {
    return AssetDetailEntity(
      id: id,
      assetName: assetName,
      assetCode: assetCode,
      unit: unit,
      status: status,
      deptName: deptName,
      isConsumable: isConsumable,
      currentRequest: currentRequest?.toEntity(),
      history: history?.map((history) => history.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class CurrentRequestModel {
  final String? borrower;
  final String? handler;
  @JsonKey(name: 'borrow_date')
  final String? borrowDate;
  @JsonKey(name: 'expected_return')
  final String? expectedReturn;
  final String? note;

  CurrentRequestModel({
    this.borrower,
    this.handler,
    this.borrowDate,
    this.expectedReturn,
    this.note,
  });

  factory CurrentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentRequestModelToJson(this);

  @override
  String toString() {
    return 'CurrentRequest(borrower: $borrower, handler: $handler, borrowDate: $borrowDate, expectedReturn: $expectedReturn, note: $note)';
  }

  CurrentRequest toEntity() {
    return CurrentRequest(
      borrower: borrower,
      handler: handler,
      borrowDate: borrowDate,
      expectedReturn: expectedReturn,
      note: note,
    );
  }
}

@JsonSerializable()
class HistoryModel {
  final String? user;
  final String? action;
  final String? date;

  HistoryModel({this.user, this.action, this.date});

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  @override
  String toString() {
    return 'History(user: $user, action: $action, date: $date)';
  }

  History toEntity() {
    return History(user: user, action: action, date: date);
  }
}

@JsonSerializable()
class AssetParam {
  final String name;
  final String description;
  final String unit;
  @JsonKey(name: 'asset_type')
  final String assetType;
  @JsonKey(name: 'deptId')
  final int deptId;

  AssetParam({
    required this.name,
    required this.description,
    required this.unit,
    required this.assetType,
    required this.deptId,
  });

  factory AssetParam.fromJson(Map<String, dynamic> json) =>
      _$AssetParamFromJson(json);
  Map<String, dynamic> toJson() => _$AssetParamToJson(this);
}
