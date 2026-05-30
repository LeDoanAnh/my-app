// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowListResponse _$BorrowListResponseFromJson(Map<String, dynamic> json) =>
    BorrowListResponse(
      success: json['success'] as bool,
      total: (json['total'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BorrowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BorrowListResponseToJson(BorrowListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'total': instance.total,
      'data': instance.data,
    };

BorrowModel _$BorrowModelFromJson(Map<String, dynamic> json) => BorrowModel(
  submissionId: (json['submission_id'] as num).toInt(),
  submissionCode: json['submission_code'] as String?,
  title: json['title'] as String?,
  isReturned: json['is_returned'] as bool?,
  userConfirmed: json['user_confirmed'] as bool?,
  isUrgent: json['is_urgent'] as bool?,
  staffName: json['staff_name'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => BorrowItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BorrowModelToJson(BorrowModel instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'submission_code': instance.submissionCode,
      'title': instance.title,
      'is_returned': instance.isReturned,
      'user_confirmed': instance.userConfirmed,
      'is_urgent': instance.isUrgent,
      'staff_name': instance.staffName,
      'items': instance.items,
    };

BorrowItemModel _$BorrowItemModelFromJson(Map<String, dynamic> json) =>
    BorrowItemModel(
      assetRequestId: (json['asset_request_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      isConsumable: json['is_consumable'] as bool?,
      status: json['status'] as String?,
      expectedReturn: json['expected_return'] as String?,
    );

Map<String, dynamic> _$BorrowItemModelToJson(BorrowItemModel instance) =>
    <String, dynamic>{
      'asset_request_id': instance.assetRequestId,
      'name': instance.name,
      'qty': instance.qty,
      'is_consumable': instance.isConsumable,
      'status': instance.status,
      'expected_return': instance.expectedReturn,
    };

BorrowActionResponse _$BorrowActionResponseFromJson(
  Map<String, dynamic> json,
) => BorrowActionResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  allReturned: json['all_returned'] as bool?,
);

Map<String, dynamic> _$BorrowActionResponseToJson(
  BorrowActionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'all_returned': instance.allReturned,
};
