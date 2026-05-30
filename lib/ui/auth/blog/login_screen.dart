import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/ui/item_widget/app_button.dart';
import 'package:my_app/ui/item_widget/app_card_container.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';
import 'package:my_app/ui/item_widget/app_logo_widget.dart';
import 'package:my_app/ui/item_widget/app_text_field.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class LoginScreen extends StatefulWidget {
  final String? initialUsername;

  const LoginScreen({super.key, this.initialUsername});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _userController;
  late final TextEditingController _passController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.initialUsername);
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            final fcmToken = await FirebaseMessaging.instance.getToken();
            if (kDebugMode) print('FCM Token: $fcmToken');

            if (fcmToken != null && context.mounted) {
              context.read<AuthBloc>().add(UpdateFcmTokenEvent(fcmToken));
            }

            if (context.mounted) {
              context.go('/main', extra: state.user);
            }
          } else if (state is AuthError) {
            _showErrorDialog(context, state.message);
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const AppLogoWidget(sizeMultiplier: 1.2),
                  const SizedBox(height: 40),
                  AppCardContainer(
                    children: [
                      Text(
                        'Chào mừng trở lại',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hệ thống quản lý tờ trình nội bộ',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AppTextField(
                        controller: _userController,
                        label: 'Tài khoản',
                        hint: 'Nhập tên đăng nhập',
                        icon: Icons.account_circle_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _passController,
                        label: 'Mật khẩu',
                        hint: 'Nhập mật khẩu',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(context),
                          child: Text(
                            'Quên mật khẩu?',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            title: 'Đăng nhập'.toUpperCase(),
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              final username = _userController.text.trim();
                              final password = _passController.text.trim();
                              if (username.isNotEmpty && password.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                  LoginSubmitted(username, password),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '(c) 2026 Portal Submission System',
                    style: TextStyle(color: Colors.black26, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Thông báo lỗi',
        content: msg,
        confirmText: 'Thử lại',
        confirmColor: AppColors.error,
        onConfirm: () {},
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Quên mật khẩu?',
        content:
            'Vui lòng liên hệ Quản trị viên (IT Support) để cấp lại mật khẩu mới.',
        confirmText: 'Đã hiểu',
        onConfirm: () {},
      ),
    );
  }
}
