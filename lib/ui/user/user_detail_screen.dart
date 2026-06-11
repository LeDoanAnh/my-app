import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/user/user_detail_bloc.dart';
import 'package:my_app/ui/user/user_detail_event.dart';
import 'package:my_app/ui/user/user_detail_state.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<UserDetailBloc>().add(GetUserDetail(widget.userId));
  }

  String _formatDate(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return 'Chưa cập nhật';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(raw.toString()));
    } catch (_) {
      return raw.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailBloc, UserDetailState>(
      builder: (context, state) {
        if (state is UserDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is UserDetailError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      onPressed: _load,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is! UserDetailLoaded) {
          return const Scaffold(body: SizedBox.shrink());
        }

        final user = state.user;
        final isActive = user.status == 'active';

        return Scaffold(
          backgroundColor: AppColors.fieldBg,
          appBar: AppBar(
            title: const Text(
              'Chi tiết nhân sự',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () async {
                  final result = await context.push<bool>(
                    '/create-user',
                    extra: user,
                  );
                  if (!context.mounted || result != true) return;
                  _load();
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Chỉnh sửa'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 20),
                _buildSectionTitle('TỔ CHỨC & PHÂN QUYỀN'),
                _buildInfoCard([
                  _buildInfoRow(
                    Icons.badge_outlined,
                    'Mã nhân viên',
                    '#${user.id}',
                  ),
                  _buildRoleRow(user.roles ?? const []),
                  _buildInfoRow(
                    Icons.account_balance,
                    'Đơn vị trực thuộc',
                    user.departmentName ?? 'Chưa phân công',
                  ),
                  _buildInfoRow(
                    Icons.calendar_month,
                    'Ngày tham gia',
                    _formatDate(user.createdAt),
                  ),
                  _buildInfoRow(
                    Icons.calendar_month,
                    'Ngày cập nhật',
                    _formatDate(user.updatedAt),
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSectionTitle('TÀI KHOẢN & BẢO MẬT'),
                _buildInfoCard([
                  _buildInfoRow(
                    Icons.alternate_email,
                    'Tên đăng nhập',
                    user.username ?? '-',
                  ),
                  _buildInfoRow(Icons.mail_outline, 'Email', user.email ?? '-'),
                  _buildStatusRow(isActive),
                ]),
                const SizedBox(height: 20),
                _buildSectionTitle('HOẠT ĐỘNG'),
                Row(
                  children: [
                    _buildStatCard(
                      'Tờ trình đã tạo',
                      '${user.totalSubmissions ?? 0}',
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Thông báo mới',
                      '${user.unreadNotifications ?? 0}',
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (isActive) _buildDeactivateButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserEntity user) {
    final name = user.fullName ?? 'Không rõ';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name.isEmpty ? '?' : name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email ?? '-',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleRow(List<RoleEntity> roles) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.admin_panel_settings,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Vai trò', style: TextStyle(color: Colors.grey)),
          ),
          Flexible(
            flex: 2,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 6,
              runSpacing: 6,
              children: roles
                  .map(
                    (role) => Chip(
                      label: Text(role.roleName ?? 'Không rõ'),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          const Text('Trạng thái', style: TextStyle(color: Colors.grey)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isActive ? Colors.green : Colors.red).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'ĐANG HOẠT ĐỘNG' : 'KHÔNG HOẠT ĐỘNG',
              style: TextStyle(
                color: isActive ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeactivateButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showDeactivateConfirmDialog,
        icon: const Icon(Icons.block_rounded, color: Colors.red),
        label: const Text(
          'NGỪNG HOẠT ĐỘNG TÀI KHOẢN',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showDeactivateConfirmDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Ngừng hoạt động tài khoản?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tài khoản sẽ được chuyển sang trạng thái không hoạt động, dữ liệu cũ vẫn được giữ lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('HỦY'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<UserDetailBloc>().add(DeactivateUser(widget.userId));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'NGỪNG HOẠT ĐỘNG',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
