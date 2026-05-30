import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/notification_entity.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final int id;
  final String? type;
  @JsonKey(name: 'user_id')
  final int? userId;
  final String? title;
  final String? message;
  @JsonKey(name: 'is_read')
  final bool? isRead;
  @JsonKey(name: 'submission_id')
  final int? submissionId;
  @JsonKey(name: 'time_ago')
  final String? timeAgo;


  NotificationModel({required this.id, this.type, this.userId, this.title, this.message, this.isRead, this.submissionId, this.timeAgo});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  @override
  String toString() {
    return 'NotificationModel(id: $id, type: $type, userId: $userId, title: $title, message: $message, isRead: $isRead, submissionId: $submissionId, timeAgo: $timeAgo)';
  }

  NotificationEntity toEntity(){
    return NotificationEntity(
      id: id,
      type: type,
      userId: userId,
      title: title,
      message: message,
      isRead: isRead,
      submissionId: submissionId,
      timeAgo: timeAgo,
    );
  }
}

@JsonSerializable()
class NotificationResponseModel {
  final List<NotificationModel>? data;
  final int? total;

  NotificationResponseModel({this.data, required this.total});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);

}