import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:my_app/ui/user/user_detail_bloc.dart';
import 'package:my_app/ui/user/user_detail_event.dart';
import 'package:my_app/ui/user/user_detail_state.dart';
import 'package:my_app/ui/user/form_user/create_user_screen.dart';
import 'package:my_app/l10n/ui_text.dart';

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
    context.read<UserDetailBloc>().add(GetUserDetail(widget.userId));
  }

  String _formatDate(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return "Chưa cập nhật";
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  TrText(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<UserDetailBloc>().add(
                      GetUserDetail(widget.userId),
                    ),
                    child: const TrText("Thử lại"),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is UserDetailLoaded) {
          final user = state.user;
          final userData = {
            "id": user.id,
            "username": user.username ?? "-",
            "full_name": user.fullName ?? "Không rõ",
            "email": user.email ?? "-",
            "roles":
                user.roles
                    ?.map((r) => {"id": r.id, "name": r.roleName ?? "Không rõ"})
                    .toList() ??
                [],
            "dept_name": user.departmentName ?? "Chưa phân công",
            "status": user.status ?? "locked",
            "created_at": _formatDate(user.createdAt),
            "updated_at": _formatDate(user.updatedAt),
            "total_submissions": user.totalSubmissions ?? 0,
            "unread_notifications": user.unreadNotifications ?? 0,
          };

          return Scaffold(
            backgroundColor: AppColors.fieldBg,
            appBar: AppBar(
              title: const TrText(
                "Chi tiết nhân sự",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.background,
              elevation: 0,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUserScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const TrText("Chỉnh sửa"),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileHeader(userData),
                  const SizedBox(height: 20),
                  _buildSectionTitle("TỔ CHỨC & PHÂN QUYỀN"),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.badge_outlined,
                      "Mã nhân viên",
                      "#${userData['id']}",
                    ),
                    _buildMultiRoleRow(
                      Icons.admin_panel_settings,
                      "Vai trò hệ thống",
                      userData['roles'] as List,
                    ),
                    _buildInfoRow(
                      Icons.account_balance,
                      "Đơn vị trực thuộc",
                      userData['dept_name'] as String,
                    ),
                    _buildInfoRow(
                      Icons.calendar_month,
                      "Ngày tham gia",
                      userData['created_at'] as String,
                    ),
                    _buildInfoRow(
                      Icons.calendar_month,
                      "Ngày cập nhật",
                      userData['updated_at'] as String,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle("TÀI KHOẢN & BẢO MẬT"),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.alternate_email,
                      "Tên đăng nhập",
                      userData['username'] as String,
                    ),
                    _buildInfoRow(
                      Icons.mail_outline,
                      "Email liên hệ",
                      userData['email'] as String,
                    ),
                    _buildStatusRow(userData['status'] as String),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle("HOẠT ĐỘNG"),
                  Row(
                    children: [
                      _buildStatCard(
                        "Tờ trình đã tạo",
                        userData['total_submissions'].toString(),
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        "Thông báo mới",
                        userData['unread_notifications'].toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildDeleteButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: SizedBox());
      },
    );
  }

  // ── Giữ nguyên 100% các widget cũ ───────────────────────────────────────

  Widget _buildMultiRoleRow(IconData icon, String label, List<dynamic> roles) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: roles.map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: TrText(
                        role['name'],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
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
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: TrText(
              userData['full_name'][0],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TrText(
            userData['full_name'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TrText(
            userData['email'],
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
        child: TrText(
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
          TrText(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Spacer(),
          TrText(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    bool isActive = status == "active" || status == "Active";
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          const TrText(
            "Trạng thái",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TrText(
              isActive ? "ĐANG HOẠT ĐỘNG" : "BỊ KHÓA",
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
            TrText(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            TrText(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showDeleteConfirmDialog(context),
        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
        label: const TrText(
          "XÓA TÀI KHOẢN NÀY",
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

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const TrText(
          "Xác nhận xóa?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const TrText(
          "Dữ liệu liên quan đến người dùng này (Tờ trình, yêu cầu vật tư) có thể bị ảnh hưởng. Bạn có chắc chắn muốn xóa vĩnh viễn không?",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TrText("HỦY", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const TrText(
              "XÓA VĨNH VIỄN",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
