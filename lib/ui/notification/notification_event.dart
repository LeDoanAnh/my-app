abstract class NotificationEvent {}

class GetNotificationList extends NotificationEvent {
  final int userId;
  GetNotificationList(this.userId);
}

class MarkAsRead extends NotificationEvent {
  final int notificationId;
  MarkAsRead(this.notificationId);
}

class MarkAllAsRead extends NotificationEvent {
  final int userId;
  MarkAllAsRead(this.userId);
}
