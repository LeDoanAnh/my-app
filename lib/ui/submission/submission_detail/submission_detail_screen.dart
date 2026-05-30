import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_screen.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_bloc.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_event.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_state.dart';
import 'package:my_app/domain/entities/submission_step.dart';
import 'package:my_app/l10n/ui_text.dart';

class SubmissionDetailScreen extends StatefulWidget {
  final int submissionId;

  const SubmissionDetailScreen({super.key, required this.submissionId});

  @override
  State<SubmissionDetailScreen> createState() => _SubmissionDetailScreenState();
}

class _SubmissionDetailScreenState extends State<SubmissionDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi event lấy dữ liệu ngay khi khởi tạo
    context.read<SubmissionDetailBloc>().add(
      GetSubmissionDetail(widget.submissionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const TrText(
          "Chi tiết tờ đơn",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: const BackButton(color: Colors.black87),
      ),
      body: BlocBuilder<SubmissionDetailBloc, SubmissionDetailState>(
        builder: (context, state) {
          if (state is SubmissionDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubmissionDetailError) {
            return Center(
              child: TrText(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SubmissionDetailLoaded) {
            final data = state.data;
            return Stack(
              // Dùng Stack để xử lý bottom action nếu cần
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(data),
                      const SizedBox(height: 24),
                      const TrText(
                        "TIẾN ĐỘ PHÊ DUYỆT",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildApprovalTimeline(data.departmentSteps ?? []),
                      const SizedBox(
                        height: 120,
                      ), // Tạo khoảng trống cho BottomSheet
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomAction(data),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // 1. Thẻ thông tin tờ đơn
  Widget _buildInfoCard(SubmissionStep data) {
    final status = data.status ?? 'pending';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5856D6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TrText(
                  data.code ?? "N/A",
                  style: const TextStyle(
                    color: Color(0xFF5856D6),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 16),
          TrText(
            data.title ?? "Không có tiêu đề",
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          TrText(
            data.content ?? "Không có nội dung",
            style: TextStyle(
              color: Colors.blueGrey[400],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Timeline Tiến độ
  Widget _buildApprovalTimeline(List<DepartmentStep> steps) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          final bool isLast = index == steps.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      _getStepIcon(step.status ?? ''),
                      color: _getStepColor(step.status ?? ''),
                      size: 22,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(width: 2, color: Colors.grey.shade100),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrText(
                              step.deptName ?? "Phòng ban",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF334155),
                              ),
                            ),
                            TrText(
                              step.time ?? "",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TrText(
                          step.comment ?? "Không có phản hồi",
                          style: TextStyle(
                            color: step.status == 'rejected'
                                ? Colors.redAccent
                                : Colors.blueGrey[400],
                            fontSize: 13,
                            fontWeight: step.status == 'rejected'
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. Footer linh hoạt
  Widget _buildBottomAction(SubmissionStep data) {
    final status = data.status ?? 'pending';
    if (status == 'pending') return const SizedBox.shrink();

    bool isRejected = status == 'rejected';
    Color mainColor = isRejected
        ? Colors.orange.shade600
        : const Color(0xFF5856D6);
    String message = isRejected
        ? "Tờ đơn bị từ chối. Bạn cần chỉnh sửa lại."
        : "Đơn đã duyệt! Bạn có thể in bản cứng.";

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRejected
                        ? Icons.info_outline
                        : Icons.check_circle_outline,
                    size: 14,
                    color: isRejected ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 6),
                  TrText(
                    message,
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSoftButton(
                label: isRejected ? "Chỉnh sửa tờ đơn" : "Yêu cầu in bản cứng",
                icon: isRejected ? Icons.edit_outlined : Icons.print_outlined,
                color: mainColor,
                onTap: () {
                  if (isRejected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateSubmissionScreen(),
                      ),
                    );
                  } else {
                    // Logic in
                  }
                },
              ),
              if (status == 'approved' &&
                  data.departmentSteps?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                TrText(
                  "Nhận tại: ${data.departmentSteps!.last.deptName}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blueGrey[300],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSED HELPERS ---
  Widget _buildSoftButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: TrText(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        backgroundColor: color.withOpacity(0.05),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _getStepColor(String status) {
    if (status == 'done') return Colors.green;
    if (status == 'rejected') return Colors.redAccent;
    return Colors.grey.shade300;
  }

  IconData _getStepIcon(String status) {
    if (status == 'done') return Icons.check_circle;
    if (status == 'rejected') return Icons.cancel;
    return Icons.radio_button_unchecked;
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    String text = "Đang chờ";
    if (status == 'approved') {
      color = Colors.green;
      text = "Đã duyệt";
    }
    if (status == 'rejected') {
      color = Colors.red;
      text = "Từ chối";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TrText(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}
