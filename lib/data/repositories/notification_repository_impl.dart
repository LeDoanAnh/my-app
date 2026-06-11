import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/notification_model.dart';
import 'package:my_app/domain/entities/notification_entity.dart';
import 'package:my_app/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final AuthApi api;

  NotificationRepositoryImpl({required this.api});

  @override
  Future<List<NotificationEntity>> getNotificationList(int userId) async {
    try {
      final NotificationResponseModel models = await api.getNotificationList(
        userId,
      );
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách thông báo thất bại: ${e.toString()}");
    }
  }

  @override
  Future<dynamic> markAsRead(int notificationId) {
    try {
      return api.markAsRead(notificationId);
    } catch (e) {
      throw Exception("Đánh dấu đã đọc thất bại: ${e.toString()}");
    }
  }

  @override
  Future<dynamic> markAllAsRead(int userId) {
    try {
      return api.markAllAsRead(userId);
    } catch (e) {
      throw Exception("Đánh dấu tất cả đã đọc thất bại: ${e.toString()}");
    }
  }
}
