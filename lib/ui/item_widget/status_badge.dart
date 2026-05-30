import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart'; // Import file màu của bạn vào đây

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    // Sử dụng logic switch-case nhưng lấy màu từ AppColors
    switch (status.toLowerCase()) {
      case 'approved':
        color = AppColors.success;
        text = "Đã duyệt";
        break;
      case 'rejected':
        color = AppColors.error;
        text = "Từ chối";
        break;
      default:
        color = AppColors.warning;
        text = "Đang chờ";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
