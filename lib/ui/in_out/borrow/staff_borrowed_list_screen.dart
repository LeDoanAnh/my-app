// ui/in_out/borrow/staff_borrowed_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/borrow_entity.dart';
import 'package:my_app/ui/in_out/borrow/borrow_bloc.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';
import 'package:my_app/l10n/ui_text.dart';

class StaffBorrowedListScreen extends StatefulWidget {
  final int userId;
  const StaffBorrowedListScreen({super.key, required this.userId});

  @override
  State<StaffBorrowedListScreen> createState() =>
      _StaffBorrowedListScreenState();
}

class _StaffBorrowedListScreenState extends State<StaffBorrowedListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BorrowBloc>().add(LoadBorrowList(userId: widget.userId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<BorrowBloc>().add(
      LoadBorrowList(
        userId: widget.userId,
        search: query.isEmpty ? null : query,
      ),
    );
  }

  void _onConfirmReceive(BorrowEntity sub) {
    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Xác nhận nhận đủ đồ?",
        content: "Bạn xác nhận đã nhận đầy đủ vật tư từ \"${sub.staffName}\"?",
        confirmText: "Đã nhận đủ",
        cancelText: "Kiểm tra lại",
        icon: Icons.check_circle_outline,
        onConfirm: () => context.read<BorrowBloc>().add(
          ConfirmReceive(submissionId: sub.submissionId, userId: widget.userId),
        ),
      ),
    );
  }

  void _onReturnAssets(BorrowEntity sub) {
    final returnableIds = sub.items
        .where((i) => !i.isConsumable && i.status == 'borrowed')
        .map((i) => i.assetRequestId!)
        .toList();

    if (returnableIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TrText("Không có vật tư nào cần trả")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Xác nhận trả đồ?",
        content:
            "Bạn xác nhận đã trả ${returnableIds.length} vật tư? Phòng ban sẽ xác nhận sau.",
        confirmText: "Trả đồ",
        cancelText: "Hủy",
        icon: Icons.outbox_rounded,
        onConfirm: () => context.read<BorrowBloc>().add(
          ReturnAssets(
            submissionId: sub.submissionId,
            userId: widget.userId,
            assetRequestIds: returnableIds,
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
        title: const TrText(
          "ĐỒ ĐANG MƯỢN",
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
      body: BlocConsumer<BorrowBloc, BorrowState>(
        listener: (context, state) {
          if (state is BorrowActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TrText(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is BorrowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TrText(state.message),
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
                child: state is BorrowLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is BorrowLoaded
                    ? state.items.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.items.length,
                              itemBuilder: (context, index) =>
                                  _buildSubmissionCard(state.items[index]),
                            )
                    : state is BorrowError
                    ? _buildErrorState(state.message)
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Widgets giữ nguyên cấu trúc cũ ─────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: uiText(context, "Tìm kiếm tờ trình..."),
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

  Widget _buildSubmissionCard(BorrowEntity sub) {
    final bool isWaitingReturn = sub.isReturned;
    final bool isNewRequest = !sub.userConfirmed && !sub.isReturned;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TrText(
                sub.submissionCode ?? "#${sub.submissionId}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusTag(sub, isUrgent, isNewRequest),
            ],
          ),
          const SizedBox(height: 8),
          TrText(
            sub.title ?? "Không có tiêu đề",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 14,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 6),
              TrText(
                "Người giao: ${sub.staffName ?? '-'}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildAssetPreview(sub.items),
          const SizedBox(height: 16),

          if (isWaitingReturn)
            _buildStatusBox(
              Icons.history_outlined,
              "Đã trả đồ - Chờ phòng ban xác nhận",
              const Color(0xFFE3F2FD),
              const Color(0xFF1976D2),
            )
          else if (isNewRequest)
            _buildActionRow(
              "Xác nhận bạn đã nhận đủ đồ?",
              "ĐÃ NHẬN ĐỦ",
              const Color(0xFFE8F5E9),
              const Color(0xFF2E7D32),
              onPressed: () => _onConfirmReceive(sub),
            )
          else if (isUrgent)
            _buildReturnActionRow(sub, true)
          else
            _buildReturnActionRow(sub, false),
        ],
      ),
    );
  }

  Widget _buildAssetPreview(List<BorrowItemEntity> items) {
    return Column(
      children: items
          .map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TrText(
                          i.name ?? "-",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                        if (i.isConsumable)
                          const TrText(
                            "• Sản phẩm không cần trả",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  TrText(
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

  Widget _buildActionRow(
    String label,
    String btnText,
    Color bgColor,
    Color textColor, {
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TrText(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            shape: const StadiumBorder(),
          ),
          child: TrText(
            btnText,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildReturnActionRow(BorrowEntity sub, bool isUrgent) {
    final Color bgColor = isUrgent
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFF3E5F5);
    final Color textColor = isUrgent
        ? const Color(0xFFC62828)
        : const Color(0xFF7B1FA2);

    // Lấy expected_return từ item đầu tiên không consumable
    final deadline = sub.items
        .where((i) => !i.isConsumable && i.expectedReturn != null)
        .map((i) => i.expectedReturn)
        .firstOrNull;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrText(
              "Hạn trả:",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            TrText(
              deadline ?? "-",
              style: TextStyle(
                color: isUrgent ? Colors.red : AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => _onReturnAssets(sub),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            shape: const StadiumBorder(),
          ),
          child: const TrText(
            "TRẢ ĐỒ",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
          TrText(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BorrowEntity sub, bool isUrgent, bool isNewReq) {
    String text = "Đang mượn";
    Color color = AppColors.primary;
    if (sub.isReturned) {
      text = "Đã trả";
      color = Colors.blue;
    } else if (isNewReq) {
      text = "Đơn mới";
      color = Colors.orange;
    } else if (isUrgent) {
      text = "Sắp hết hạn";
      color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TrText(
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
          TrText(
            "Không có đồ đang mượn",
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
          TrText(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<BorrowBloc>().add(
              LoadBorrowList(userId: widget.userId),
            ),
            child: const TrText("Thử lại"),
          ),
        ],
      ),
    );
  }
}
