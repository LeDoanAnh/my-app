import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final bool showCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText,
    this.cancelText,
    this.confirmColor,
    this.icon,
    this.onCancel,
    this.showCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveConfirmColor = confirmColor ?? AppColors.primary;
    final effectiveConfirmText = confirmText ?? 'Xác nhận';
    final effectiveCancelText = cancelText ?? 'Hủy';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: effectiveConfirmColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ??
                    (effectiveConfirmColor == AppColors.error
                        ? Icons.warning_amber_rounded
                        : Icons.info_rounded),
                color: effectiveConfirmColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 250),
                      );
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: effectiveConfirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      effectiveConfirmText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (showCancel) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context, false);
                        await Future<void>.delayed(
                          const Duration(milliseconds: 250),
                        );
                        onCancel?.call();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textGrey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        effectiveCancelText,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
