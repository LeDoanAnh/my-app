// data/model/borrow_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'borrow_model.g.dart';

@JsonSerializable()
class BorrowListResponse {
  final bool success;
  final int? total;
  final List<BorrowModel>? data;

  BorrowListResponse({required this.success, this.total, this.data});
  factory BorrowListResponse.fromJson(Map<String, dynamic> json) =>
      _$BorrowListResponseFromJson(json);
}

@JsonSerializable()
class BorrowModel {
  @JsonKey(name: 'submission_id')
  final int submissionId;
  @JsonKey(name: 'submission_code')
  final String? submissionCode;
  final String? title;
  @JsonKey(name: 'is_returned')
  final bool? isReturned;
  @JsonKey(name: 'user_confirmed')
  final bool? userConfirmed;
  @JsonKey(name: 'is_urgent')
  final bool? isUrgent;
  @JsonKey(name: 'staff_name')
  final String? staffName;
  final List<BorrowItemModel>? items;

  BorrowModel({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.isReturned,
    this.userConfirmed,
    this.isUrgent,
    this.staffName,
    this.items,
  });
  factory BorrowModel.fromJson(Map<String, dynamic> json) =>
      _$BorrowModelFromJson(json);
}

@JsonSerializable()
class BorrowItemModel {
  @JsonKey(name: 'asset_request_id')
  final int? assetRequestId;
  final String? name;
  final int? qty;
  @JsonKey(name: 'is_consumable')
  final bool? isConsumable;
  final String? status;
  @JsonKey(name: 'expected_return')
  final String? expectedReturn;

  BorrowItemModel({
    this.assetRequestId,
    this.name,
    this.qty,
    this.isConsumable,
    this.status,
    this.expectedReturn,
  });
  factory BorrowItemModel.fromJson(Map<String, dynamic> json) =>
      _$BorrowItemModelFromJson(json);
}

@JsonSerializable()
class BorrowActionResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'all_returned')
  final bool? allReturned;

  BorrowActionResponse({
    required this.success,
    required this.message,
    this.allReturned,
  });
  factory BorrowActionResponse.fromJson(Map<String, dynamic> json) =>
      _$BorrowActionResponseFromJson(json);
}
