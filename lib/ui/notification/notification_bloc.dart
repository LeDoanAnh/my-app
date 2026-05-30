import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/notification_entity.dart';
import 'package:my_app/domain/usecases/notification_use_case.dart';
import 'package:my_app/ui/notification/notification_event.dart';
import 'package:my_app/ui/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationUseCase useCase;
  NotificationBloc({required this.useCase}) : super(NotificationInitial()) {
    on<GetNotificationList>(_onGetNotificationList);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
  }
  Future<void> _onGetNotificationList(
    GetNotificationList event,
    Emitter<NotificationState> emit,
  ) async {
    final int userId = event.userId;
    if (state is! NotificationLoaded) {
      emit(NotificationLoading());
    }
    try {
      final notifications = await useCase.getNotificationList(userId);
      emit(NotificationLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationError("Lỗi tải dữ liệu thông báo: ${e.toString()}"));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final int notificationId = event.notificationId;
    try {
      await useCase.markAsRead(notificationId);
      emit(
        NotificationLoaded(
          notifications: (state as NotificationLoaded).notifications,
        ),
      );
    } catch (e) {
      emit(NotificationError("Lỗi đánh dấu đã đọc: ${e.toString()}"));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      // 1. Tạo danh sách mới đã được đánh dấu đọc hết (Optimistic Update)
      final updatedNotifications = currentState.notifications.map((
        notification,
      ) {
        return NotificationEntity(
          id: notification.id,
          type: notification.type,
          userId: notification.userId,
          title: notification.title,
          message: notification.message,
          submissionId: notification.submissionId,
          timeAgo: notification.timeAgo,
          isRead: true,
        );
      }).toList();
      emit(NotificationLoaded(notifications: updatedNotifications));
      final int userId = event.userId;
      try {
        await useCase.markAllAsRead(userId);
        emit(
          NotificationLoaded(
            notifications: (state as NotificationLoaded).notifications,
          ),
        );
      } catch (e) {
        emit(NotificationError("Lỗi đánh dấu tất cả đã đọc: ${e.toString()}"));
      }
    }
  }
}
