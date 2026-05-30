// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isRead: json['is_read'] as bool?,
      submissionId: (json['submission_id'] as num?)?.toInt(),
      timeAgo: json['time_ago'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'user_id': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'submission_id': instance.submissionId,
      'time_ago': instance.timeAgo,
    };

NotificationResponseModel _$NotificationResponseModelFromJson(
  Map<String, dynamic> json,
) => NotificationResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationResponseModelToJson(
  NotificationResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'total': instance.total};
