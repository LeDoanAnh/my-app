import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/user_entity.dart';

class DynamicDashboardScreen extends StatelessWidget {
  final UserEntity user;

  const DynamicDashboardScreen({super.key, required this.user});

  bool _hasRole(int id) => user.roles!.any((role) => role.id == id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildAdminHero(context),
            const SizedBox(height: 24),

            if (_hasRole(1)) ...[
              _buildAdminSection(
                context,
                "QUẢN LÝ LUỒNG DUYỆT",
                Icons.account_tree_rounded,
                [
                  _DashboardAction(
                    title: "Thêm luồng duyệt",
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () => context.push('/create-workflow'),
                  ),
                  _DashboardAction(
                    title: "Danh sách luồng",
                    icon: Icons.format_list_bulleted_rounded,
                    onTap: () => context.push('/workflow-list'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildAdminSection(
                context,
                "QUẢN LÝ PHÒNG BAN",
                Icons.people_alt_rounded,
                [
                  _DashboardAction(
                    title: "Tạo phòng ban",
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () => context.push('/create-department'),
                  ),
                  _DashboardAction(
                    title: "Danh sách phòng",
                    icon: Icons.format_list_bulleted_rounded,
                    onTap: () => context.push('/department-list'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildAdminSection(
                context,
                "QUẢN LÝ CSVC",
                Icons.category_rounded,
                [
                  _DashboardAction(
                    title: "Tạo mới CSVC",
                    icon: Icons.add_shopping_cart_rounded,
                    onTap: () => context.push('/create-resource'),
                  ),
                  _DashboardAction(
                    title: "Danh sách CSVC",
                    icon: Icons.assignment_rounded,
                    onTap: () => context.push('/asset-location-list'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildAdminSection(
                context,
                "QUẢN LÝ NGƯỜI DÙNG",
                Icons.manage_accounts_rounded,
                [
                  _DashboardAction(
                    title: "Thêm người dùng",
                    icon: Icons.person_add_rounded,
                    onTap: () => context.push('/create-user'),
                  ),
                  _DashboardAction(
                    title: "Danh sách User",
                    icon: Icons.badge_rounded,
                    onTap: () => context.push('/user-list'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],

            if (_hasRole(3) || _hasRole(4) || _hasRole(1)) ...[
              _buildAdminSection(
                context,
                "QUẢN LÝ ĐƠN XUẤT/NHẬP KHO",
                Icons.inventory_rounded,
                [
                  _DashboardAction(
                    title: "Danh sách đn bàn giao",
                    icon: Icons.add_shopping_cart_rounded,
                    onTap: () => context.push(
                      '/asset-submission-list',
                      extra: {
                        'deptId': user.departmentId!,
                        'handlerId': user.id,
                      },
                    ),
                  ),
                  _DashboardAction(
                    title: "Danh sách đã mượn",
                    icon: Icons.auto_stories_rounded,
                    onTap: () =>
                        context.push('/staff-borrowed-list/${user.id}'),
                  ),
                  _DashboardAction(
                    title: "Danh sách đơn mượn",
                    icon: Icons.assignment_rounded,
                    onTap: () =>
                        context.push('/manager-recovery-list/${user.id}'),
                  ),
                  _DashboardAction(
                    title: "Lịch sử mượn",
                    icon: Icons.history_rounded,
                    onTap: () => context.push(
                      '/history',
                      extra: {
                        'userId': user.id,
                        'userRoles': user.roles!.map((e) => e.id).toList(),
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],

            if (_hasRole(2)) ...[
              _buildAdminSection(
                context,
                "QUẢN LÝ ĐỒ NHẬN",
                Icons.shopping_bag_rounded,
                [
                  _DashboardAction(
                    title: "Danh sách đã mượn",
                    icon: Icons.auto_stories_rounded,
                    onTap: () =>
                        context.push('/staff-borrowed-list/${user.id}'),
                  ),
                  _DashboardAction(
                    title: "Lịch sử mượn",
                    icon: Icons.history_rounded,
                    onTap: () => context.push(
                      '/history',
                      extra: {
                        'userId': user.id,
                        'userRoles': user.roles!.map((e) => e.id).toList(),
                      },
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    if (_hasRole(1)) return "Hệ Thống Quản Trị";
    if (_hasRole(3)) return "Quản Lý Đơn Vị";
    return "Cổng Thông Tin";
  }

  Widget _buildAdminHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_pin_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Xin chào, ${user.fullName}!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _hasRole(1)
                          ? "Quyền hạn: Quản trị viên"
                          : "Quyền hạn: Nhân sự đơn vị",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "Vận hành hệ thống & tờ trình",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/create-submission'),
            icon: const Icon(
              Icons.post_add_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            label: const Text(
              "TẠO TỜ TRÌNH MỚI",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSection(
    BuildContext context,
    String title,
    IconData mainIcon,
    List<_DashboardAction> actions,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(mainIcon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: AppColors.textGrey,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              thickness: 0.8,
              color: AppColors.borderSubtle,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: actions.length == 1 ? 1 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: actions.length == 1 ? 5.0 : 2.8,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: action.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.fieldBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: actions.length == 1
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Icon(action.icon, size: 20, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            action.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Helper model thay Map<String, dynamic> ────────────────────────
class _DashboardAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
