import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_event.dart';
import 'package:my_app/ui/auth/blog/auth_state.dart';
import 'package:my_app/ui/item_widget/app_card_container.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          final apiMessage = state.message ?? 'Đăng xuất';
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AppConfirmationDialog(
              title: 'Thông báo',
              content: apiMessage,
              confirmText: 'OK',
              showCancel: false,
              onConfirm: () {
                context.go('/login');
              },
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final userDisplayName = (state is Authenticated)
              ? state.user.username
              : 'Người dùng';

          return Material(
            color: const Color(0xFFF8F9FE),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildUserCard(context, userDisplayName),
                        const SizedBox(height: 25),
                        _buildSectionTitle('Cài đặt'),
                        _buildMenuItem(
                          Icons.settings_outlined,
                          'Cài đặt/Bảo mật',
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Hỗ trợ'),
                        _buildMenuItem(
                          Icons.help_outline_rounded,
                          'Trung tâm trợ giúp',
                        ),
                        const SizedBox(height: 30),
                        _buildLogoutButton(context),
                        const SizedBox(height: 25),
                        Center(
                          child: Text(
                            '${'Phiên bản'} 2.2.3',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
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

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B3E),
              ),
            ),
            const Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: Color(0xFF0D1B3E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, String name) {
    return AppCardContainer(
      children: [
        const Center(
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFF0F1F5),
            child: Icon(Icons.person, size: 55, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_filled,
              size: 18,
              color: Colors.orange,
            ),
            const SizedBox(width: 6),
            Text(
              'Chưa xác minh',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D1B3E),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0D1B3E), size: 26),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0D1B3E)),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AppConfirmationDialog(
            title: 'Đăng xuất',
            content: 'Bạn có chắc chắn muốn thoát tài khoản không?',
            confirmText: 'Đăng xuất',
            confirmColor: Colors.redAccent,
            onConfirm: () {
              context.read<AuthBloc>().add(LogoutPressed());
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0D1B3E), width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Đăng xuất',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
        ),
      ),
    );
  }
}
