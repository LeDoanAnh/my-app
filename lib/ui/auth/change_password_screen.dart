import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_event.dart';
import 'package:my_app/ui/auth/blog/auth_state.dart';
import 'package:my_app/ui/item_widget/app_button.dart';
import 'package:my_app/ui/item_widget/app_card_container.dart';
import 'package:my_app/ui/item_widget/app_logo_widget.dart';
import 'package:my_app/ui/item_widget/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated && state.user.isFirstLogin != true) {
            context.go('/main', extra: state.user);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.secondary, AppColors.background],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const AppLogoWidget(sizeMultiplier: 1),
                  const SizedBox(height: 32),
                  AppCardContainer(
                    children: [
                      const Text(
                        'Đổi mật khẩu',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bạn cần đổi mật khẩu trong lần đăng nhập đầu tiên.',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        controller: _currentPasswordController,
                        label: 'Mật khẩu hiện tại',
                        hint: 'Nhập mật khẩu hiện tại',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isVisible: _isCurrentVisible,
                        onToggleVisibility: () {
                          setState(
                            () => _isCurrentVisible = !_isCurrentVisible,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _newPasswordController,
                        label: 'Mật khẩu mới',
                        hint: 'Nhập mật khẩu mới',
                        icon: Icons.lock_reset,
                        isPassword: true,
                        isVisible: _isNewVisible,
                        onToggleVisibility: () {
                          setState(() => _isNewVisible = !_isNewVisible);
                        },
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: 'Xác nhận mật khẩu',
                        hint: 'Nhập lại mật khẩu mới',
                        icon: Icons.verified_user_outlined,
                        isPassword: true,
                        isVisible: _isConfirmVisible,
                        onToggleVisibility: () {
                          setState(
                            () => _isConfirmVisible = !_isConfirmVisible,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) => AppButton(
                          title: 'CẬP NHẬT MẬT KHẨU',
                          isLoading: state is AuthLoading,
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Xác nhận mật khẩu không khớp');
      return;
    }

    context.read<AuthBloc>().add(
      ChangePasswordSubmitted(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
