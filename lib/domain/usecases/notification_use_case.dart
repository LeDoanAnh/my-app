import 'package:my_app/data/model/notification_model.dart';
import 'package:my_app/domain/entities/notification_entity.dart';
import 'package:my_app/domain/repositories/notification_repository.dart';

class NotificationUseCase {
  final NotificationRepository repository;

  NotificationUseCase(this.repository);

  Future<List<NotificationEntity>> getNotificationList(int userId) async {
    return await repository.getNotificationList(userId);
  }

  Future<dynamic> markAsRead(int notificationId) async {
    return await repository.markAsRead(notificationId);
  }

  Future<dynamic> markAllAsRead(int userId) async {
    return await repository.markAllAsRead(userId);
  }
}
