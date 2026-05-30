class NotificationEntity {
  final int id;
  final String? type;
  final int? userId;
  final String? title;
  final String? message;
  final bool? isRead;
  final int? submissionId;
  final String? timeAgo;

  NotificationEntity({required this.id, this.type, this.userId, this.title, this.message, this.isRead, this.submissionId, this.timeAgo});
}