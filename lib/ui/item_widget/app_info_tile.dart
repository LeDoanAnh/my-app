//màn thông tin trong cart nhìn nội dung của màn profile

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AppInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isCopyable;

  const AppInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          if (isCopyable)
            Icon(
              Icons.copy_all_rounded,
              size: 18,
              color: AppColors.primary.withOpacity(0.3),
            ),
        ],
      ),
    );
  }
}
