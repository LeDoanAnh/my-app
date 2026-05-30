import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/approver_aubmission_entity.dart';
import 'package:my_app/ui/in_out/approver_decison/approver_bloc.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

class ApproverDecisionScreen extends StatefulWidget {
  final int submissionId;
  final int deptId;
  final int approverId;

  const ApproverDecisionScreen({
    super.key,
    required this.submissionId,
    required this.deptId,
    required this.approverId,
  });

  @override
  State<ApproverDecisionScreen> createState() => _ApproverDecisionScreenState();
}

class _ApproverDecisionScreenState extends State<ApproverDecisionScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool? _lastDecisionIsApprove;
  bool _isShowingResultDialog = false;
  bool _handlingDecisionInPasswordDialog = false;

  @override
  void initState() {
    super.initState();
    context.read<ApproverBloc>().add(
      LoadApproverSubmission(
        submissionId: widget.submissionId,
        deptId: widget.deptId,
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproverBloc, ApproverState>(
      listener: (context, state) {
        if (_handlingDecisionInPasswordDialog &&
            (state is ApproverDecideSuccess || state is ApproverActionError)) {
          return;
        }
        if (state is ApproverDecideSuccess) {
          _showDecisionResultDialog(success: true, message: state.message);
        } else if (state is ApproverActionError) {
          _showDecisionResultDialog(success: false, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is ApproverLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ApproverError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
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
                    onPressed: () => context.read<ApproverBloc>().add(
                      LoadApproverSubmission(
                        submissionId: widget.submissionId,
                        deptId: widget.deptId,
                      ),
                    ),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ApproverLoaded) {
          return _buildMain(context, state.submission);
        }
        if (state is ApproverDeciding) {
          return _buildMain(context, state.submission);
        }
        if (state is ApproverActionError) {
          return _buildMain(context, state.submission);
        }
        return const Scaffold(body: SizedBox());
      },
    );
  }

  Widget _buildMain(BuildContext context, ApproverSubmissionEntity submission) {
    final alreadyDecided = submission.myDecision != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/main');
            }
          },
        ),
        title: const Text(
          "Chi tiáº¿t phÃª duyá»‡t",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (alreadyDecided) ...[
                  _buildDecisionBanner(submission.myDecision!),
                  const SizedBox(height: 20),
                ],

                _buildMainContentCard(submission),
                const SizedBox(height: 20),

                if (submission.startTime != null ||
                    submission.endTime != null) ...[
                  _buildSectionLabel("THá»œI GIAN"),
                  _buildTimeCard(submission),
                  const SizedBox(height: 20),
                ],

                if (submission.locations != null &&
                    submission.locations!.isNotEmpty) ...[
                  _buildSectionLabel("Äá»ŠA ÄIá»‚M (PHÃ’NG BAN Báº N)"),
                  _buildLocationsCard(submission.locations!),
                  const SizedBox(height: 20),
                ],

                if (submission.assets != null &&
                    submission.assets!.isNotEmpty) ...[
                  _buildSectionLabel("Váº¬T TÆ¯ (PHÃ’NG BAN Báº N)"),
                  _buildAssetsCard(submission.assets!),
                  const SizedBox(height: 20),
                ],

                if (!alreadyDecided) ...[
                  _buildSectionLabel("GHI CHÃš PHÃŠ DUYá»†T"),
                  _buildCommentInput(),
                ],
              ],
            ),
          ),

          if (!alreadyDecided) _buildBottomActionBar(submission),
        ],
      ),
    );
  }

  // â”€â”€ Banner Ä‘Ã£ xá»­ lÃ½ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildDecisionBanner(MyDecisionEntity decision) {
    final isApproved = decision.action == 'approved';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.08)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApproved
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isApproved ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isApproved
                      ? "Báº¡n Ä‘Ã£ duyá»‡t tá» trÃ¬nh nÃ y"
                      : "Báº¡n Ä‘Ã£ tá»« chá»‘i tá» trÃ¬nh nÃ y",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isApproved ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
                if (decision.comment != null &&
                    decision.comment!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "\"${decision.comment}\"",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (decision.decidedAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    decision.decidedAt!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Card ná»™i dung chÃ­nh â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildMainContentCard(ApproverSubmissionEntity submission) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFEFF6FF),
                radius: 18,
                child: Icon(Icons.description, color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  submission.title ?? "KhÃ´ng cÃ³ tiÃªu Ä‘á»",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.person_outline,
            "NgÆ°á»i gá»­i",
            submission.sender ?? "-",
            Colors.blueGrey,
          ),
          const SizedBox(height: 12),
          Text(
            submission.content ?? "",
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.6,
            ),
          ),

          if (submission.noteForDept != null &&
              submission.noteForDept!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFEF3C7)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      submission.noteForDept!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF92400E),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // â”€â”€ Card thá»i gian â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildTimeCard(ApproverSubmissionEntity submission) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (submission.startTime != null)
            _buildInfoRow(
              Icons.play_circle_outline,
              "Báº¯t Ä‘áº§u",
              submission.startTime!,
              Colors.green,
            ),
          if (submission.startTime != null && submission.endTime != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1),
            ),
          if (submission.endTime != null)
            _buildInfoRow(
              Icons.stop_circle_outlined,
              "Káº¿t thÃºc",
              submission.endTime!,
              Colors.red,
            ),
        ],
      ),
    );
  }

  // â”€â”€ Card Ä‘á»‹a Ä‘iá»ƒm â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildLocationsCard(List<ApproverLocationEntity> locations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: locations.asMap().entries.map((entry) {
          final i = entry.key;
          final loc = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.location_on,
                      loc.locationName ?? "-",
                      "",
                      Colors.redAccent,
                    ),
                    if (loc.startTime != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 30),
                          const Icon(
                            Icons.access_time,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${loc.startTime} â†’ ${loc.endTime ?? ''}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (i < locations.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ Card váº­t tÆ° â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildAssetsCard(List<ApproverAssetEntity> assets) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: assets.asMap().entries.map((entry) {
          final i = entry.key;
          final asset = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 14,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        asset.assetName ?? "-",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "x${asset.quantity ?? 1}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < assets.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ Input ghi chÃº â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "ThÃªm ghi chÃº phÃª duyá»‡t (náº¿u cÃ³)...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // â”€â”€ Bottom action bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildBottomActionBar(ApproverSubmissionEntity submission) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showPasswordDialogWithLoading(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Tá»ª CHá»I",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showPasswordDialogWithLoading(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "DUYá»†T ÄÆ N",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A3B8),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        ),
        if (value.isNotEmpty) ...[
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showDecisionResultDialog({
    required bool success,
    required String message,
  }) async {
    if (_isShowingResultDialog) return;
    _isShowingResultDialog = true;

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      _isShowingResultDialog = false;
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppConfirmationDialog(
        title: success ? 'Thành công' : 'Thất bại',
        content: message,
        confirmText: success ? 'OK' : 'Thực hiện lại',
        cancelText: 'Hủy',
        confirmColor: success ? AppColors.success : AppColors.error,
        icon: success
            ? Icons.check_circle_rounded
            : Icons.error_outline_rounded,
        showCancel: !success,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    _isShowingResultDialog = false;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted || confirmed != true) return;

    if (success) {
      if (context.canPop()) {
        context.pop(true);
      } else {
        context.go('/main');
      }
      return;
    }

    final lastDecision = _lastDecisionIsApprove;
    if (lastDecision == null) return;
    _showPasswordDialogWithLoading(lastDecision);
  }

  Future<void> _showPasswordDialogWithLoading(bool isApprove) async {
    final passwordController = TextEditingController();
    String? passwordError;
    bool obscurePassword = true;
    bool isSubmitting = false;
    ApproverState? resultState;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Future<void> submit() async {
            final password = passwordController.text.trim();
            if (password.isEmpty) {
              setDialogState(() => passwordError = 'Nhập mật khẩu');
              return;
            }
            if (isSubmitting) return;

            setDialogState(() {
              isSubmitting = true;
              passwordError = null;
            });

            _lastDecisionIsApprove = isApprove;
            _handlingDecisionInPasswordDialog = true;
            final bloc = context.read<ApproverBloc>();
            final resultFuture = bloc.stream.firstWhere(
              (state) =>
                  state is ApproverDecideSuccess ||
                  state is ApproverActionError,
            );
            bloc.add(
              DecideSubmission(
                submissionId: widget.submissionId,
                approverId: widget.approverId,
                action: isApprove ? 'approved' : 'rejected',
                password: password,
                comment: _commentController.text.trim(),
              ),
            );

            resultState = await resultFuture;

            _handlingDecisionInPasswordDialog = false;
            if (ctx.mounted) {
              Navigator.of(ctx).pop();
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Xác nhận mật khẩu',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: passwordController,
              enabled: !isSubmitting,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu để tiếp tục',
                errorText: passwordError,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () => setDialogState(() {
                          obscurePassword = !obscurePassword;
                        }),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) {
                if (passwordError != null) {
                  setDialogState(() => passwordError = null);
                }
              },
              onSubmitted: (_) {
                if (!isSubmitting) submit();
              },
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
                child: Text(
                  'Hủy',
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
              ElevatedButton(
                onPressed: isSubmitting ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApprove ? Colors.green : Colors.redAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('Tiếp tục'),
              ),
            ],
          );
        },
      ),
    );

    _handlingDecisionInPasswordDialog = false;
    passwordController.dispose();

    if (!mounted || resultState == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    final state = resultState!;
    if (state is ApproverDecideSuccess) {
      await _showDecisionResultDialog(success: true, message: state.message);
    } else if (state is ApproverActionError) {
      await _showDecisionResultDialog(success: false, message: state.message);
    }
  }

  // âœ… FIX: Bá» await Future.delayed(Duration.zero) - nguyÃªn nhÃ¢n gÃ¢y lá»—i _dependents.isEmpty
  Future<void> _showPasswordDialog(bool isApprove) async {
    final passwordController = TextEditingController();
    String? passwordError;
    bool obscurePassword = true;

    final password = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Xác nhận mật khẩu',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              hintText: 'Nhập mật khẩu để tiếp tục',
              errorText: passwordError,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                onPressed: () => setDialogState(() {
                  obscurePassword = !obscurePassword;
                }),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) {
              if (passwordError != null) {
                setDialogState(() => passwordError = null);
              }
            },
            onSubmitted: (_) {
              final pwd = passwordController.text.trim();
              if (pwd.isEmpty) {
                setDialogState(() => passwordError = 'Nhập mật khẩu');
                return;
              }
              Navigator.of(ctx).pop(pwd);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Hủy',
                style: const TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final pwd = passwordController.text.trim();
                if (pwd.isEmpty) {
                  setDialogState(() => passwordError = 'Nhập mật khẩu');
                  return;
                }
                Navigator.of(ctx).pop(pwd);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? Colors.green : Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );

    // âœ… Dispose controller ngay sau khi dialog Ä‘Ã³ng
    passwordController.dispose();

    // âœ… Check mounted NGAY - khÃ´ng cáº§n await Future.delayed ná»¯a
    if (!mounted || password == null || password.isEmpty) return;

    _lastDecisionIsApprove = isApprove;
    context.read<ApproverBloc>().add(
      DecideSubmission(
        submissionId: widget.submissionId,
        approverId: widget.approverId,
        action: isApprove ? 'approved' : 'rejected',
        password: password,
        comment: _commentController.text.trim(),
      ),
    );
  }

  void _showConfirmDialog(bool isApprove, String password) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isApprove ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isApprove ? Colors.green : Colors.redAccent,
            ),
            const SizedBox(width: 8),
            Text(
              isApprove ? "XÃ¡c nháº­n duyá»‡t?" : "XÃ¡c nháº­n tá»« chá»‘i?",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isApprove
              ? "Báº¡n Ä‘á»“ng Ã½ phÃª duyá»‡t tá» trÃ¬nh nÃ y. HÃ nh Ä‘á»™ng nÃ y khÃ´ng thá»ƒ hoÃ n tÃ¡c."
              : "Báº¡n sáº½ tá»« chá»‘i tá» trÃ¬nh nÃ y. ToÃ n bá»™ quy trÃ¬nh sáº½ bá»‹ dá»«ng láº¡i.",
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Hủy',
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final bloc = context.read<ApproverBloc>();
              final comment = _commentController.text.trim();
              Navigator.of(ctx).pop();
              if (!mounted) return;
              bloc.add(
                DecideSubmission(
                  submissionId: widget.submissionId,
                  approverId: widget.approverId,
                  action: isApprove ? 'approved' : 'rejected',
                  password: password,
                  comment: comment,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? Colors.green : Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isApprove ? "Duyá»‡t" : "Tá»« chá»‘i"),
          ),
        ],
      ),
    );
  }
}
