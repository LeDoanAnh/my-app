import 'package:json_annotation/json_annotation.dart';
part 'recovery_model.g.dart';

@JsonSerializable()
class RecoveryListResponse {
  final bool success;
  final int? total;
  final List<RecoveryModel>? data;

  RecoveryListResponse({required this.success, this.total, this.data});

  factory RecoveryListResponse.fromJson(Map<String, dynamic> json) => _$RecoveryListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryListResponseToJson(this);
}

@JsonSerializable()
class RecoveryModel {
  @JsonKey(name: 'submission_id')
  final int submissionId;
  @JsonKey(name: 'submission_code')
  final String? submissionCode;
  final String? title;
  @JsonKey(name: 'borrower_name')
  final String? borrowerName;
  @JsonKey(name: 'borrower_id')
  final int? borrowerId;
  @JsonKey(name: 'is_returned')
  final bool? isReturned;
  @JsonKey(name: 'user_confirmed')
  final bool? userConfirmed;
  @JsonKey(name: 'is_urgent')
  final bool? isUrgent;
  @JsonKey(name: 'return_date')
  final String? returnDate;
  final List<RecoveryItemModel>? items;

  RecoveryModel({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.borrowerName,
    this.borrowerId,
    this.isReturned,
    this.userConfirmed,
    this.isUrgent,
    this.returnDate,
    this.items,
  });
  factory RecoveryModel.fromJson(Map<String, dynamic> json) => _$RecoveryModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryModelToJson(this);
}

@JsonSerializable()
class RecoveryItemModel {
  @JsonKey(name: 'asset_request_id')
  final int? assetRequestId;
  final String? name;
  final int? qty;
  final String? status;
  @JsonKey(name: 'expected_return')
  final String? expectedReturn;

  RecoveryItemModel({
    this.assetRequestId,
    this.name,
    this.qty,
    this.status,
    this.expectedReturn,
  });
  factory RecoveryItemModel.fromJson(Map<String, dynamic> json) => _$RecoveryItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryItemModelToJson(this);
}

@JsonSerializable()
class RecoveryActionResponseModel {
  final bool success;
  final String message;

  RecoveryActionResponseModel({required this.success, required this.message});
  factory RecoveryActionResponseModel.fromJson(Map<String, dynamic> json) => _$RecoveryActionResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryActionResponseModelToJson(this);
}