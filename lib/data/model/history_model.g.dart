// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowHistoryListResponse _$BorrowHistoryListResponseFromJson(
  Map<String, dynamic> json,
) => BorrowHistoryListResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => BorrowHistoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BorrowHistoryListResponseToJson(
  BorrowHistoryListResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

BorrowHistoryModel _$BorrowHistoryModelFromJson(Map<String, dynamic> json) =>
    BorrowHistoryModel(
      submissionId: (json['submission_id'] as num).toInt(),
      submissionCode: json['submission_code'] as String?,
      title: json['title'] as String?,
      borrowerName: json['borrower_name'] as String?,
      receiverName: json['receiver_name'] as String?,
      completedDate: json['completed_date'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BorrowHistoryModelToJson(BorrowHistoryModel instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'submission_code': instance.submissionCode,
      'title': instance.title,
      'borrower_name': instance.borrowerName,
      'receiver_name': instance.receiverName,
      'completed_date': instance.completedDate,
      'items': instance.items,
    };

HandoverHistoryListResponse _$HandoverHistoryListResponseFromJson(
  Map<String, dynamic> json,
) => HandoverHistoryListResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => HandoverHistoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HandoverHistoryListResponseToJson(
  HandoverHistoryListResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

HandoverHistoryModel _$HandoverHistoryModelFromJson(
  Map<String, dynamic> json,
) => HandoverHistoryModel(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String?,
  title: json['title'] as String?,
  fromDept: json['from_dept'] as String?,
  toDept: json['to_dept'] as String?,
  handoverBy: json['handover_by'] as String?,
  handoverDate: json['handover_date'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HandoverHistoryModelToJson(
  HandoverHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'title': instance.title,
  'from_dept': instance.fromDept,
  'to_dept': instance.toDept,
  'handover_by': instance.handoverBy,
  'handover_date': instance.handoverDate,
  'items': instance.items,
};

HistoryItemModel _$HistoryItemModelFromJson(Map<String, dynamic> json) =>
    HistoryItemModel(
      name: json['name'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      isConsumable: json['is_consumable'] as bool?,
    );

Map<String, dynamic> _$HistoryItemModelToJson(HistoryItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qty': instance.qty,
      'is_consumable': instance.isConsumable,
    };
