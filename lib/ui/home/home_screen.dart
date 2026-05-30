import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/ui/home/home_bloc.dart';
import 'package:my_app/ui/home/home_event.dart';
import 'package:my_app/ui/home/home_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class HomeScreen extends StatefulWidget {
  final UserEntity user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasRole(int id) => widget.user.roles!.any((role) => role.id == id);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeDataEvent(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              onRefresh: () async {
                context.read<HomeBloc>().add(
                  RefreshHomeDataEvent(userId: widget.user.id),
                );
                await context.read<HomeBloc>().stream.firstWhere(
                  (s) => s is HomeLoaded || s is HomeError,
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildMobileAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPersonalStats(
                            total: state.stats.total.toString(),
                            pending: state.stats.pending.toString(),
                            rejected: state.stats.rejected.toString(),
                          ),
                          const SizedBox(height: 24),
                          if (canCreate || canApprove) ...[
                            _buildSectionHeader(
                              l10n.manageSubmissions,
                              Icons.description_rounded,
                            ),
                            const SizedBox(height: 12),
                            _buildSubmissionQuickActions(
                              context,
                              canCreate,
                              canApprove,
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (canManageAssets || isAdmin) ...[
                            _buildSectionHeader(
                              l10n.manageAssets,
                              Icons.inventory_2_rounded,
                            ),
                            const SizedBox(height: 12),
                            _buildAssetGrid(context),
                            const SizedBox(height: 24),
                          ],
                          _buildSectionHeader(
                            l10n.recentActivities,
                            Icons.history_rounded,
                          ),
                          const SizedBox(height: 12),
                          _buildRecentActivityList(
                            context,
                            state.recentSubmissions,
                          ),
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

  Widget _buildMobileAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverAppBar(
      backgroundColor: AppColors.background,
      pinned: true,
      floating: true,
      elevation: 0,
      centerTitle: false,
      title: TrText(
        l10n.appShortTitle,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.textDark),
          onPressed: () => context.push('/search/${widget.user.id}'),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textDark,
          ),
          onPressed: () => context.push('/notification/${widget.user.id}'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPersonalStats({
    required String total,
    required String pending,
    required String rejected,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statColumn(total, l10n.totalSubmissions),
          _statColumn(pending, l10n.pending),
          _statColumn(rejected, l10n.rejected),
        ],
      ),
    );
  }

  Widget _statColumn(String value, String label) {
    return Column(
      children: [
        TrText(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TrText(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        TrText(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionQuickActions(
    BuildContext context,
    bool canCreate,
    bool canApprove,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        if (canCreate)
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.push('/create-submission', extra: widget.user.id),
              child: _actionCard(
                l10n.createRequest,
                Icons.add_circle_outline,
                AppColors.primary,
              ),
            ),
          ),
        if (canCreate && canApprove) const SizedBox(width: 12),
        if (canApprove)
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/submission-list', extra: widget.user),
              child: _actionCard(
                l10n.requestInbox,
                Icons.fact_check_outlined,
                AppColors.success,
              ),
            ),
          ),
      ],
    );
  }

  Widget _actionCard(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          TrText(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push(
              '/asset-submission-list',
              extra: {
                'deptId': widget.user.departmentId!,
                'handlerId': widget.user.id,
              },
            ),
            child: _assetMiniCard(
              l10n.handover,
              Icons.outbox_rounded,
              Colors.teal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () =>
                context.push('/manager-recovery-list/${widget.user.id}'),
            child: _assetMiniCard(
              l10n.recovery,
              Icons.move_to_inbox_rounded,
              AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _assetMiniCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          TrText(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(
    BuildContext context,
    List<SubmissionEntity> submissions,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (submissions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(child: TrText(l10n.noRecentActivities)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: submissions.length > 4 ? 4 : submissions.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final item = submissions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.description_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: TrText(
              item.title ?? l10n.untitled,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: TrText(
              item.statusLabel ?? l10n.noStatus,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: TrText(
              item.time ?? l10n.noTime,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          TrText(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<HomeBloc>().add(
              GetHomeDataEvent(userId: widget.user.id),
            ),
            child: TrText(l10n.retry),
          ),
        ],
      ),
    );
  }
}
