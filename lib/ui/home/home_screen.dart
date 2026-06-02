import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/home/home_bloc.dart';
import 'package:my_app/ui/home/home_event.dart';
import 'package:my_app/ui/home/home_state.dart';

class HomeScreen extends StatefulWidget {
  final UserEntity user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasRole(int id) => widget.user.roles!.any((r) => r.id == id);

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng ☀️';
    if (h < 18) return 'Chào buổi chiều 🌤';
    return 'Chào buổi tối 🌙';
  }

  String get _initials {
    final name = widget.user.fullName ?? '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeDataEvent(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _hasRole(1);
    final canApprove = _hasRole(3) || isAdmin;
    final canManageAssets = _hasRole(4) || isAdmin || canApprove;
    final canCreate = _hasRole(2) || isAdmin || canApprove || canManageAssets;

    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is HomeError) {
            return _buildErrorState(context, state.message);
          }
          if (state is HomeLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context
                    .read<HomeBloc>()
                    .add(RefreshHomeDataEvent(userId: widget.user.id));
                await context
                    .read<HomeBloc>()
                    .stream
                    .firstWhere((s) => s is HomeLoaded || s is HomeError);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreeting(),
                          const SizedBox(height: 16),
                          _buildStatsCard(
                            total: state.stats.total.toString(),
                            pending: state.stats.pending.toString(),
                            rejected: state.stats.rejected.toString(),
                          ),
                          if (canCreate || canApprove) ...[
                            const SizedBox(height: 24),
                            _buildSectionHeader(
                              'Quản lý tờ trình',
                              Icons.description_rounded,
                              AppColors.noteBg,
                              AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            _buildSubmissionActions(
                                context, canCreate, canApprove),
                          ],
                          if (canManageAssets || isAdmin) ...[
                            const SizedBox(height: 24),
                            _buildSectionHeader(
                              'Quản lý vật tư',
                              Icons.inventory_2_rounded,
                              AppColors.warningBg,
                              AppColors.warningDark,
                            ),
                            const SizedBox(height: 12),
                            _buildAssetRow(context),
                          ],
                          const SizedBox(height: 24),
                          _buildSectionHeader(
                            'Hoạt động gần đây',
                            Icons.history_rounded,
                            AppColors.infoBgSoft,
                            AppColors.info,
                          ),
                          const SizedBox(height: 12),
                          _buildActivityList(
                              context, state.recentSubmissions),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      pinned: true,
      floating: true,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'E-Submission',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        _iconButton(
          Icons.search_rounded,
          onTap: () => context.push('/search/${widget.user.id}'),
        ),
        _iconButton(
          Icons.notifications_none_rounded,
          onTap: () => context.push('/notification/${widget.user.id}'),
          badge: true,
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _iconButton(IconData icon,
      {required VoidCallback onTap, bool badge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            if (badge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Greeting ─────────────────────────────────────────────────────────────

  Widget _buildGreeting() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.user.fullName ?? 'Người dùng',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            _initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // ── Stats card ───────────────────────────────────────────────────────────

  Widget _buildStatsCard({
    required String total,
    required String pending,
    required String rejected,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THỐNG KÊ TỜ TRÌNH CỦA BẠN',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(total, 'Tổng đơn'),
                VerticalDivider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 1,
                  width: 1,
                ),
                _statItem(pending, 'Đang chờ'),
                VerticalDivider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 1,
                  width: 1,
                ),
                _statItem(rejected, 'Từ chối'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(
      String title, IconData icon, Color bgColor, Color iconColor) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  // ── Submission actions ───────────────────────────────────────────────────

  Widget _buildSubmissionActions(
      BuildContext context, bool canCreate, bool canApprove) {
    return Row(
      children: [
        if (canCreate)
          Expanded(
            child: _actionCard(
              label: 'Tạo đơn',
              sub: 'Tờ trình mới',
              icon: Icons.add_circle_outline_rounded,
              iconBg: AppColors.primary.withOpacity(0.10),
              iconColor: AppColors.primary,
              onTap: () =>
                  context.push('/create-submission', extra: widget.user.id),
            ),
          ),
        if (canCreate && canApprove) const SizedBox(width: 12),
        if (canApprove)
          Expanded(
            child: _actionCard(
              label: 'Phê duyệt',
              sub: 'Chờ xử lý',
              icon: Icons.fact_check_outlined,
              iconBg: AppColors.success.withOpacity(0.12),
              iconColor: AppColors.success,
              onTap: () =>
                  context.push('/submission-list', extra: widget.user),
            ),
          ),
      ],
    );
  }

  Widget _actionCard({
    required String label,
    required String sub,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Asset row ────────────────────────────────────────────────────────────

  Widget _buildAssetRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _assetCard(
            title: 'Bàn giao',
            icon: Icons.outbox_rounded,
            color: Colors.teal,
            bg: Colors.teal.withOpacity(0.08),
            border: Colors.teal.withOpacity(0.18),
            onTap: () => context.push('/asset-submission-list', extra: {
              'deptId': widget.user.departmentId!,
              'handlerId': widget.user.id,
            }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _assetCard(
            title: 'Thu hồi',
            icon: Icons.move_to_inbox_rounded,
            color: AppColors.error,
            bg: AppColors.error.withOpacity(0.08),
            border: AppColors.error.withOpacity(0.15),
            onTap: () =>
                context.push('/manager-recovery-list/${widget.user.id}'),
          ),
        ),
      ],
    );
  }

  Widget _assetCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color border,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Activity list ────────────────────────────────────────────────────────

  Widget _buildActivityList(
      BuildContext context, List<SubmissionEntity> submissions) {
    if (submissions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox_rounded, size: 36, color: AppColors.textGrey),
            SizedBox(height: 8),
            Text(
              'Không có hoạt động gần đây',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final count = submissions.length > 4 ? 4 : submissions.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, indent: 62, endIndent: 0),
        itemBuilder: (context, i) {
          final item = submissions[i];
          return _activityTile(item);
        },
      ),
    );
  }

  Widget _activityTile(SubmissionEntity item) {
    final status = item.statusLabel ?? '';
    Color statusColor;
    Color statusBg;

    if (status.toLowerCase().contains('duyệt') &&
        !status.toLowerCase().contains('chờ')) {
      statusColor = AppColors.success;
      statusBg = AppColors.success.withOpacity(0.10);
    } else if (status.toLowerCase().contains('từ chối') ||
        status.toLowerCase().contains('reject')) {
      statusColor = AppColors.error;
      statusBg = AppColors.error.withOpacity(0.10);
    } else {
      statusColor = AppColors.warningDark;
      statusBg = AppColors.warningBg;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Không có tiêu đề',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.isNotEmpty ? status : 'Không có trạng thái',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time ?? '',
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ──────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.cloud_off_rounded,
                size: 36, color: AppColors.error),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context
                .read<HomeBloc>()
                .add(GetHomeDataEvent(userId: widget.user.id)),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}