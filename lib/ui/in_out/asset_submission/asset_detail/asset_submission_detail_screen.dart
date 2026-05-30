import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';
import 'package:my_app/ui/in_out/asset_submission/asset_detail/asset_task_bloc.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

class AssetSubmissionDetailScreen extends StatefulWidget {
  final int submissionId;
  final int deptId;
  final int handlerId;

  const AssetSubmissionDetailScreen({
    super.key,
    required this.submissionId,
    required this.deptId,
    required this.handlerId,
  });

  @override
  State<AssetSubmissionDetailScreen> createState() =>
      _AssetSubmissionDetailScreenState();
}

class _AssetSubmissionDetailScreenState
    extends State<AssetSubmissionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AssetTaskBloc>().add(
      LoadAssetTaskDetail(
        submissionId: widget.submissionId,
        deptId: widget.deptId,
      ),
    );
  }

  void _onHandover(AssetTaskDetailEntity detail) {
    final assetRequestIds =
        detail.assets
            ?.where((a) => a.status == 'pending')
            .map((a) => a.assetId!)
            .toList() ??
        [];

    if (assetRequestIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có vật tư nào cần bàn giao")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Xác nhận bàn giao",
        content:
            "Xác nhận bàn giao ${assetRequestIds.length} vật tư cho người mượn?",
        confirmText: "Bàn giao",
        cancelText: "Kiểm tra lại",
        icon: Icons.outbox_rounded,
        onConfirm: () {
          context.read<AssetTaskBloc>().add(
            HandoverAssets(
              submissionId: widget.submissionId,
              handlerId: widget.handlerId,
              assetRequestIds: assetRequestIds,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetTaskBloc, AssetTaskState>(
      listener: (context, state) {
        if (state is AssetTaskHandoverSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          if (state.allHandedOver)
            Navigator.pop(context, true);
          else {
            context.read<AssetTaskBloc>().add(
              LoadAssetTaskDetail(
                submissionId: widget.submissionId,
                deptId: widget.deptId,
              ),
            );
          }
        } else if (state is AssetTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AssetTaskLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AssetTaskError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<AssetTaskBloc>().add(
                      LoadAssetTaskDetail(
                        submissionId: widget.submissionId,
                        deptId: widget.deptId,
                      ),
                    ),
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is AssetTaskDetailLoaded) {
          return _buildMain(context, state.detail);
        }
        return const Scaffold(body: SizedBox());
      },
    );
  }

  Widget _buildMain(BuildContext context, AssetTaskDetailEntity detail) {
    final hasPending =
        detail.assets?.any((a) => a.status == 'pending') ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          "Chi tiết đơn #${detail.id}",
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatusBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Thông tin chung"),
                  _buildInfoCard(detail),
                  const SizedBox(height: 20),
                  if (detail.approvedBy != null) ...[
                    _buildSectionTitle("Thông tin phê duyệt"),
                    _buildApprovalCard(detail.approvedBy!),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionTitle("Danh sách vật tư kê khai"),
                  _buildAssetList(detail.assets ?? []),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: hasPending ? _buildBottomAction(context, detail) : null,
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFFECFDF5),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: Color(0xFF10B981),
          ),
          SizedBox(width: 8),
          Text(
            "Đơn đã được ký duyệt - Sẵn sàng bàn giao",
            style: TextStyle(
              color: Color(0xFF065F46),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AssetTaskDetailEntity detail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.title, "Tiêu đề đơn", detail.title ?? "-"),
          const Divider(height: 30),
          _buildInfoRow(
            Icons.person_outline,
            "Người yêu cầu",
            detail.sender ?? "-",
          ),
          const Divider(height: 30),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            "Ngày cập nhật",
            detail.date ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(ApprovedByEntity approvedBy) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.history_edu, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Người ký duyệt",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  approvedBy.name ?? "-",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                ),
                if (approvedBy.comment != null &&
                    approvedBy.comment!.isNotEmpty)
                  Text(
                    "\"${approvedBy.comment}\"",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            approvedBy.approvedAt ?? "-",
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetList(List<AssetTaskItemEntity> assets) {
    return Column(
      children: assets.map((asset) {
        final isReturnable = asset.type == 'returnable';
        final isBorrowed = asset.status == 'borrowed';
        final isReturned = asset.status == 'returned';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isBorrowed
                ? Border.all(color: Colors.green.withOpacity(0.3))
                : isReturned
                ? Border.all(color: Colors.grey.withOpacity(0.3))
                : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isBorrowed
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.fieldBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: isBorrowed ? Colors.green : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.assetName ?? "-",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          asset.assetCode ?? "",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildTypeBadge(isReturnable),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isBorrowed
                          ? Colors.green.withOpacity(0.1)
                          : isReturned
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isBorrowed
                          ? "Đã giao"
                          : isReturned
                          ? "Đã trả"
                          : "Chờ giao",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isBorrowed
                            ? Colors.green
                            : isReturned
                            ? Colors.grey
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),

              if (asset.borrower != null) ...[
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Người mượn: ${asset.borrower!.name} - ${asset.borrower!.dept}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ],

              if (isReturnable && asset.expectedReturn != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.event_repeat,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Ngày trả dự kiến: ${asset.expectedReturn}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypeBadge(bool isReturnable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isReturnable
            ? Colors.orange.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isReturnable ? "Mượn tạm thời" : "Tiêu hao / Cấp phát",
        style: TextStyle(
          color: isReturnable ? Colors.orange[800] : Colors.blue[800],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    AssetTaskDetailEntity detail,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _onHandover(detail),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "BÀN GIAO",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
