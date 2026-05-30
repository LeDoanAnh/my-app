import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/recovery_entity.dart';
import 'package:my_app/ui/in_out/recovery/recovery_bloc.dart';
import 'package:my_app/ui/in_out/recovery/recovery_event.dart';
import 'package:my_app/ui/in_out/recovery/recovery_state.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

class ManagerRecoveryListScreen extends StatefulWidget {
  final int handlerId;
  const ManagerRecoveryListScreen({super.key, required this.handlerId});

  @override
  State<ManagerRecoveryListScreen> createState() =>
      _ManagerRecoveryListScreenState();
}

class _ManagerRecoveryListScreenState extends State<ManagerRecoveryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RecoveryBloc>().add(
      LoadRecoveryList(handlerId: widget.handlerId),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<RecoveryBloc>().add(
      LoadRecoveryList(
        handlerId: widget.handlerId,
        search: query.isEmpty ? null : query,
      ),
    );
  }

  void _onConfirmRecovery(RecoveryEntity sub) {
    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Xác nhận đã thu hồi?",
        content:
            "Bạn xác nhận đã nhận lại đầy đủ vật tư từ \"${sub.borrowerName}\"?",
        confirmText: "Đã thu hồi",
        cancelText: "Kiểm tra lại",
        icon: Icons.check_circle_outline,
        onConfirm: () => context.read<RecoveryBloc>().add(
          ConfirmRecovery(
            submissionId: sub.submissionId,
            handlerId: widget.handlerId,
          ),
        ),
      ),
    );
  }

  void _onRemindReturn(RecoveryEntity sub) {
    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Gửi nhắc nhở?",
        content: "Gửi thông báo nhắc \"${sub.borrowerName}\" trả đồ trước hạn?",
        confirmText: "Gửi nhắc",
        cancelText: "Hủy",
        icon: Icons.notifications_active_outlined,
        onConfirm: () => context.read<RecoveryBloc>().add(
          RemindReturn(
            submissionId: sub.submissionId,
            handlerId: widget.handlerId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          "QUẢN LÝ THU HỒI",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<RecoveryBloc, RecoveryState>(
        listener: (context, state) {
          if (state is RecoveryActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is RecoveryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: state is RecoveryLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is RecoveryLoaded
                    ? state.items.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.items.length,
                              itemBuilder: (context, index) =>
                                  _buildRecoveryCard(state.items[index]),
                            )
                    : state is RecoveryError
                    ? _buildErrorState(state.message)
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Widgets ─────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: "Tìm tên người mượn hoặc tờ trình...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF1F3F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildRecoveryCard(RecoveryEntity sub) {
    final bool isUserPendingConfirm = !sub.userConfirmed;
    final bool isWaitingManagerConfirm = sub.isReturned;
    final bool isUrgent = sub.isUrgent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sub.submissionCode ?? "#${sub.submissionId}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusTag(
                isUserPendingConfirm,
                isWaitingManagerConfirm,
                isUrgent,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            sub.title ?? "Không có tiêu đề",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Borrower info
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 14,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 6),
              Text(
                "Người mượn: ",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                sub.borrowerName ?? '-',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(height: 24),
          _buildAssetPreview(sub.items),
          const SizedBox(height: 16),

          // Action section theo trạng thái
          if (isUserPendingConfirm)
            _buildStatusBox(
              Icons.hourglass_bottom,
              "Chờ người mượn xác nhận đã nhận đồ",
              const Color(0xFFFFF3E0),
              const Color(0xFFE65100),
            )
          else if (isWaitingManagerConfirm)
            _buildFullWidthButton(sub)
          else if (isUrgent)
            _buildActionRow(
              returnDate: sub.returnDate,
              isUrgent: true,
              label: "NHẮC TRẢ",
              bgColor: const Color(0xFFFFEBEE),
              textColor: const Color(0xFFC62828),
              icon: Icons.notifications_active_outlined,
              onPressed: () => _onRemindReturn(sub),
            )
          else
            _buildActionRow(returnDate: sub.returnDate, isUrgent: false),
        ],
      ),
    );
  }

  Widget _buildAssetPreview(List<RecoveryItemEntity> items) {
    return Column(
      children: items
          .map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                  Expanded(
                    child: Text(
                      i.name ?? "-",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Text(
                    "x${i.qty ?? 1}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFullWidthButton(RecoveryEntity sub) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _onConfirmRecovery(sub),
        icon: const Icon(Icons.check_circle_outline, size: 18),
        label: const Text(
          "XÁC NHẬN ĐÃ THU HỒI",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8F5E9),
          foregroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required String? returnDate,
    required bool isUrgent,
    String? label,
    Color? bgColor,
    Color? textColor,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hạn trả:",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Text(
              returnDate ?? "-",
              style: TextStyle(
                color: isUrgent ? Colors.red : AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (label != null && onPressed != null)
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 16),
            label: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: textColor,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
          )
        else
          const Text(
            "Đang sử dụng",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBox(
    IconData icon,
    String text,
    Color bgColor,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(
    bool isPendingUser,
    bool isWaitingManager,
    bool isUrgent,
  ) {
    String text = "Đang mượn";
    Color color = AppColors.primary;
    if (isPendingUser) {
      text = "Chờ nhận";
      color = Colors.orange;
    } else if (isWaitingManager) {
      text = "Chờ thu hồi";
      color = Colors.green;
    } else if (isUrgent) {
      text = "Sắp quá hạn";
      color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Không có đồ cần thu hồi",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<RecoveryBloc>().add(
              LoadRecoveryList(handlerId: widget.handlerId),
            ),
            child: const Text("Thử lại"),
          ),
        ],
      ),
    );
  }
}
