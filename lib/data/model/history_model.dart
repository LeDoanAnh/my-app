import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

// ── Borrow History ───────────────────────────────────────────

@JsonSerializable()
class BorrowHistoryListResponse {
  final bool success;
  final List<BorrowHistoryModel>? data;

  BorrowHistoryListResponse({required this.success, this.data});

  factory BorrowHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$BorrowHistoryListResponseFromJson(json);
}

@JsonSerializable()
class BorrowHistoryModel {
  @JsonKey(name: 'submission_id') final int submissionId;
  @JsonKey(name: 'submission_code') final String? submissionCode;
  final String? title;
  @JsonKey(name: 'borrower_name') final String? borrowerName;
  @JsonKey(name: 'receiver_name') final String? receiverName;
  @JsonKey(name: 'completed_date') final String? completedDate;
  final List<HistoryItemModel>? items;

  BorrowHistoryModel({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.borrowerName,
    this.receiverName,
    this.completedDate,
    this.items,
  });

  factory BorrowHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$BorrowHistoryModelFromJson(json);
}

// ── Handover History ─────────────────────────────────────────

@JsonSerializable()
class HandoverHistoryListResponse {
  final bool success;
  final List<HandoverHistoryModel>? data;

  HandoverHistoryListResponse({required this.success, this.data});

  factory HandoverHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$HandoverHistoryListResponseFromJson(json);
}

@JsonSerializable()
class HandoverHistoryModel {
  final int id;
  final String? code;
  final String? title;
  @JsonKey(name: 'from_dept') final String? fromDept;
  @JsonKey(name: 'to_dept') final String? toDept;
  @JsonKey(name: 'handover_by') final String? handoverBy;
  @JsonKey(name: 'handover_date') final String? handoverDate;
  final List<HistoryItemModel>? items;

  HandoverHistoryModel({
    required this.id,
    this.code,
    this.title,
    this.fromDept,
    this.toDept,
    this.handoverBy,
    this.handoverDate,
    this.items,
  });

  factory HandoverHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverHistoryModelFromJson(json);
}

// ── Item ─────────────────────────────────────────────────────

@JsonSerializable()
class HistoryItemModel {
  final String? name;
  final int? qty;
  @JsonKey(name: 'is_consumable') final bool? isConsumable;

  HistoryItemModel({this.name, this.qty, this.isConsumable});

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemModelFromJson(json);
}