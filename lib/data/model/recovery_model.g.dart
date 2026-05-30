// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryListResponse _$RecoveryListResponseFromJson(
  Map<String, dynamic> json,
) => RecoveryListResponse(
  success: json['success'] as bool,
  total: (json['total'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => RecoveryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecoveryListResponseToJson(
  RecoveryListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'data': instance.data,
};

RecoveryModel _$RecoveryModelFromJson(Map<String, dynamic> json) =>
    RecoveryModel(
      submissionId: (json['submission_id'] as num).toInt(),
      submissionCode: json['submission_code'] as String?,
      title: json['title'] as String?,
      borrowerName: json['borrower_name'] as String?,
      borrowerId: (json['borrower_id'] as num?)?.toInt(),
      isReturned: json['is_returned'] as bool?,
      userConfirmed: json['user_confirmed'] as bool?,
      isUrgent: json['is_urgent'] as bool?,
      returnDate: json['return_date'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => RecoveryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecoveryModelToJson(RecoveryModel instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'submission_code': instance.submissionCode,
      'title': instance.title,
      'borrower_name': instance.borrowerName,
      'borrower_id': instance.borrowerId,
      'is_returned': instance.isReturned,
      'user_confirmed': instance.userConfirmed,
      'is_urgent': instance.isUrgent,
      'return_date': instance.returnDate,
      'items': instance.items,
    };

RecoveryItemModel _$RecoveryItemModelFromJson(Map<String, dynamic> json) =>
    RecoveryItemModel(
      assetRequestId: (json['asset_request_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      status: json['status'] as String?,
      expectedReturn: json['expected_return'] as String?,
    );

Map<String, dynamic> _$RecoveryItemModelToJson(RecoveryItemModel instance) =>
    <String, dynamic>{
      'asset_request_id': instance.assetRequestId,
      'name': instance.name,
      'qty': instance.qty,
      'status': instance.status,
      'expected_return': instance.expectedReturn,
    };

RecoveryActionResponseModel _$RecoveryActionResponseModelFromJson(
  Map<String, dynamic> json,
) => RecoveryActionResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$RecoveryActionResponseModelToJson(
  RecoveryActionResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
