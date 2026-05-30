import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/notification_entity.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/ui/notification/notification_bloc.dart';
import 'package:my_app/ui/notification/notification_event.dart';
import 'package:my_app/ui/notification/notification_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class NotificationScreen extends StatefulWidget {
  final int userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetNotificationList(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: TrText(
          l10n.notifications,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                MarkAllAsRead(widget.userId),
              );
            },
            child: TrText(
              l10n.markAllRead,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            return notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return _buildNotificationItem(item);
                    },
                  );
          } else if (state is NotificationError) {
            return Center(child: TrText(state.message));
          }
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationEntity item) {
    Color statusColor;
    IconData statusIcon;

    switch (item.type) {
      case 'success':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'error':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_rounded;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        statusIcon = Icons.error_rounded;
        break;
      default:
        statusColor = AppColors.primary;
        statusIcon = Icons.info_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: (item.isRead ?? false)
            ? AppColors.background
            : AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            context.read<NotificationBloc>().add(MarkAsRead(item.id));

            if (item.submissionId != null) {
              if (item.type == 'warning') {
                await context.push<bool>(
                  '/approver-decision',
                  extra: {
                    'submissionId': item.submissionId!,
                    'deptId': 1,
                    'approverId': widget.userId,
                  },
                );
                if (mounted) {
                  context.read<NotificationBloc>().add(
                    GetNotificationList(widget.userId),
                  );
                }
              } else {
                context.push('/submission-detail/${item.submissionId}');
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TrText(
                              item.title ?? '',
                              style: TextStyle(
                                fontWeight: (item.isRead ?? false)
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          if (!(item.isRead ?? false))
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TrText(
                        item.message ?? '',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TrText(
                        item.timeAgo ?? '',
                        style: TextStyle(
                          color: AppColors.textGrey.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          TrText(
            l10n.noNotifications,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
