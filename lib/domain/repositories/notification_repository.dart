import 'package:my_app/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotificationList(int userId);

  Future<dynamic> markAsRead(int notificationId);

  Future<dynamic> markAllAsRead(int userId);
}
