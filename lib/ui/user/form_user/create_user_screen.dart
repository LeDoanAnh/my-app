import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/data/model/create_user_params.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';
import 'package:my_app/ui/user/form_user/form_user_bloc.dart';
import 'package:my_app/ui/user/form_user/form_user_event.dart';
import 'package:my_app/ui/user/form_user/form_user_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<int> _selectedRoleIds = [];
  DepartmentEntity? _selectedDept;
  bool _isActive = true;
  bool _showPassword = false;

  // Data từ API
  List<RoleEntity> _roles = [];
  List<DepartmentEntity> _departments = [];

  @override
  void initState() {
    super.initState();
    // Trigger load roles + departments khi màn hình khởi tạo
    context.read<CreateUserBloc>().add(GetRoleList());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Sinh mật khẩu ngẫu nhiên đủ: chữ thường + chữ hoa + số (tối thiểu 8 ký tự)
  String _generatePassword() {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';
    const all = lower + upper + digits;
    final rng = Random.secure();

    // Đảm bảo ít nhất 1 ký tự mỗi nhóm
    final chars = [
      lower[rng.nextInt(lower.length)],
      upper[rng.nextInt(upper.length)],
      digits[rng.nextInt(digits.length)],
      // 5 ký tự ngẫu nhiên còn lại
      ...List.generate(5, (_) => all[rng.nextInt(all.length)]),
    ];
    chars.shuffle(rng);
    return chars.join();
  }

  void _toggleRole(int roleId) {
    setState(() {
      if (_selectedRoleIds.contains(roleId)) {
        _selectedRoleIds.remove(roleId);
      } else {
        _selectedRoleIds.add(roleId);
      }
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TrText('Vui lòng chọn ít nhất một vai trò')),
      );
      return;
    }
    if (_selectedDept == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TrText('Vui lòng chọn phòng ban')),
      );
      return;
    }

    final params = CreateUserParams(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      departmentId: _selectedDept!.id,
      roleIds: _selectedRoleIds,
      status: _isActive ? 'active' : 'locked',
    );

    context.read<CreateUserBloc>().add(SubmitCreateUser(params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateUserBloc, CreateUserState>(
      listener: (context, state) {
        if (state is CreateUserFormReady) {
          setState(() {
            _roles = state.roles;
            _departments = state.departments;
          });
        }
        if (state is CreateUserSubmitSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppConfirmationDialog(
              title: "Tạo tài khoản thành công!",
              content: state.message,
              confirmText: "Quay về",
              cancelText: "Tạo thêm",
              icon: Icons.check_circle_outline_rounded,
              confirmColor: Colors.green,
              onConfirm: () => Navigator.pop(context),
              onCancel: () {
                // Reset toàn bộ form để tạo tiếp
                _fullNameController.clear();
                _usernameController.clear();
                _emailController.clear();
                _passwordController.clear();
                setState(() {
                  _selectedRoleIds = [];
                  _selectedDept = null;
                  _isActive = true;
                });
              },
            ),
          );
        }
        if (state is CreateUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TrText(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.fieldBg,
        appBar: AppBar(
          title: const TrText(
            "Tạo tài khoản mới",
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textDark,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<CreateUserBloc, CreateUserState>(
          builder: (context, state) {
            if (state is CreateUserRoleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final isSubmitting = state is CreateUserSubmitLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepHeader("1", "THÔNG TIN CÁ NHÂN"),
                    _buildFormSection([
                      _buildInputField(
                        _fullNameController,
                        "Họ và tên",
                        Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Vui lòng nhập họ tên'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        _emailController,
                        "Địa chỉ Email",
                        Icons.email_outlined,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Vui lòng nhập email';
                          if (!RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$',
                          ).hasMatch(v)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ]),

                    const SizedBox(height: 25),
                    _buildStepHeader("2", "THIẾT LẬP TÀI KHOẢN"),
                    _buildFormSection([
                      _buildInputField(
                        _usernameController,
                        "Tên đăng nhập",
                        Icons.alternate_email,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Vui lòng nhập tên đăng nhập'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(),
                    ]),

                    const SizedBox(height: 25),
                    _buildStepHeader("3", "PHÂN QUYỀN & ĐƠN VỊ"),
                    _buildFormSection([
                      _buildMultiRoleSelector(),
                      const SizedBox(height: 16),
                      _buildDepartmentDropdown(),
                      const SizedBox(height: 12),
                      _buildStatusToggle(),
                    ]),

                    const SizedBox(height: 40),
                    _buildSubmitButton(isSubmitting),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Field mật khẩu có nút "Tạo tự động" và toggle hiện/ẩn
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
            if (!RegExp(r'(?=.*[a-z])').hasMatch(v))
              return 'Cần có ít nhất 1 chữ thường';
            if (!RegExp(r'(?=.*[A-Z])').hasMatch(v))
              return 'Cần có ít nhất 1 chữ hoa';
            if (!RegExp(r'(?=.*\d)').hasMatch(v))
              return 'Cần có ít nhất 1 chữ số';
            if (v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
            return null;
          },
          decoration: InputDecoration(
            hintText: uiText(context, "Mật khẩu ban đầu"),
            prefixIcon: const Icon(
              Icons.lock_open_rounded,
              size: 20,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
            filled: true,
            fillColor: AppColors.fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        // Nút sinh mật khẩu tự động
        GestureDetector(
          onTap: () {
            final pwd = _generatePassword();
            setState(() {
              _passwordController.text = pwd;
              _showPassword = true; // Hiện để user thấy mật khẩu vừa tạo
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              TrText(
                "Tạo mật khẩu tự động",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Dropdown phòng ban lấy từ API
  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<DepartmentEntity>(
      value: _selectedDept,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.business_outlined,
          size: 20,
          color: AppColors.primary,
        ),
        hintText: uiText(context, "Phòng ban / Đơn vị"),
        filled: true,
        fillColor: AppColors.fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: _departments
          .map(
            (dept) => DropdownMenuItem(
              value: dept,
              child: TrText(dept.deptName ?? 'Không tên'),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedDept = val),
    );
  }

  /// Multi-select role từ API
  Widget _buildMultiRoleSelector() {
    if (_roles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: TrText(
          "Đang tải danh sách vai trò...",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 20,
              color: AppColors.primary,
            ),
            SizedBox(width: 12),
            TrText(
              "Vai trò người dùng (Có thể chọn nhiều)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: _roles.map((role) {
            final isSelected = _selectedRoleIds.contains(role.id);
            return FilterChip(
              label: TrText(role.roleName ?? 'Không tên'),
              selected: isSelected,
              onSelected: (_) => _toggleRole(role.id ?? 0),
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              backgroundColor: AppColors.fieldBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepHeader(String step, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.primary,
            child: TrText(
              step,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 8),
          TrText(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInputField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isPass = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: isPass,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TrText(
            "Trạng thái hoạt động",
            style: TextStyle(color: Colors.grey),
          ),
          Switch(
            value: _isActive,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _isActive = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isSubmitting) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const TrText(
                "TẠO TÀI KHOẢN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
