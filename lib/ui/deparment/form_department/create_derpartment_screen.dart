import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/deparment/form_department/form_department_bloc.dart';
import 'package:my_app/ui/deparment/form_department/form_department_event.dart';
import 'package:my_app/ui/deparment/form_department/form_department_state.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

class CreateDepartmentScreen extends StatefulWidget {
  const CreateDepartmentScreen({super.key});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deptNameController = TextEditingController();
  final TextEditingController _locationDescController = TextEditingController();
  DepartmentEntity? _selectedParentDept;

  @override
  void initState() {
    super.initState();
    context.read<FormDepartmentBloc>().add(GetDepartmentList());
  }

  @override
  void dispose() {
    _deptNameController.dispose();
    _locationDescController.dispose();
    super.dispose();
  }

  // ── Dialog xác nhận thoát ────────────────────────────────────────────────

  Future<bool> _onWillPop() async {
    if (_deptNameController.text.isEmpty &&
        _locationDescController.text.isEmpty) {
      return true;
    }
    bool shouldPop = false;
    await showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Hủy tạo phòng ban?",
        content: "Thông tin bạn đã nhập sẽ bị mất. Bạn có chắc muốn quay lại?",
        confirmText: "Rời khỏi",
        cancelText: "Tiếp tục nhập",
        icon: Icons.exit_to_app_rounded,
        confirmColor: AppColors.error,
        onConfirm: () => shouldPop = true,
      ),
    );
    return shouldPop;
  }

  // ── Dialog xác nhận submit ───────────────────────────────────────────────

  void _onSubmit(List<DepartmentEntity> departments) {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AppConfirmationDialog(
          title: "Xác nhận tạo phòng ban",
          content:
              "Bạn có chắc muốn tạo phòng ban \"${_deptNameController.text.trim()}\""
              "${_selectedParentDept != null ? ' thuộc ${_selectedParentDept!.deptName}' : ''}?",
          confirmText: "Tạo phòng ban",
          cancelText: "Kiểm tra lại",
          icon: Icons.business_rounded,
          onConfirm: () {
            context.read<FormDepartmentBloc>().add(
              SubmitCreateDepartment(
                deptName: _deptNameController.text.trim(),
                locationDesc: _locationDescController.text.trim(),
                parentDeptId: _selectedParentDept?.id,
              ),
            );
          },
        ),
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final should = await _onWillPop();
        if (should && context.mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.fieldBg,
        appBar: AppBar(
          title: const Text(
            "Tạo phòng ban mới",
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
            onPressed: () async {
              final should = await _onWillPop();
              if (should && context.mounted) Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<FormDepartmentBloc, FormDepartmentState>(
          listener: (context, state) {
            if (state is FormDepartmentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is FormDepartmentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FormDepartmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<DepartmentEntity> departments = [];
            bool isDeptLoading = false;

            if (state is FormDepartmentLoaded) {
              departments = state.departments;
            } else if (state is FormDepartmentInitial) {
              isDeptLoading = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nhập thông tin để thiết lập đơn vị mới trong hệ thống.",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                    const SizedBox(height: 25),

                    _buildStepHeader("1", "THÔNG TIN ĐƠN VỊ"),
                    _buildFormSection([
                      _buildInputField(
                        _deptNameController,
                        "Tên phòng ban (VD: Phòng Công nghệ)",
                        Icons.business_rounded,
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Vui lòng nhập tên phòng"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        _locationDescController,
                        "Vị trí / Địa chỉ (VD: Phòng 802 KTX K1)",
                        Icons.location_on_outlined,
                      ),
                    ]),

                    const SizedBox(height: 25),
                    _buildStepHeader("2", "CẤU TRÚC TỔ CHỨC"),
                    _buildFormSection([
                      isDeptLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : _buildDepartmentDropdown(departments),
                    ]),

                    const SizedBox(height: 40),
                    _buildSubmitButton(departments),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Dropdown ─────────────────────────────────────────────────────────────

  Widget _buildDepartmentDropdown(List<DepartmentEntity> departments) {
    return DropdownButtonFormField<DepartmentEntity>(
      value: _selectedParentDept,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.account_tree_outlined,
          size: 20,
          color: AppColors.primary,
        ),
        hintText: "Trực thuộc đơn vị (Parent Department)",
        filled: true,
        fillColor: AppColors.fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      hint: const Text("Trực thuộc đơn vị", style: TextStyle(fontSize: 14)),
      items: [
        const DropdownMenuItem<DepartmentEntity>(
          value: null,
          child: Text("Không có (Đơn vị gốc)"),
        ),
        ...departments.map(
          (dept) => DropdownMenuItem<DepartmentEntity>(
            value: dept,
            child: Text(dept.deptName ?? "Không rõ"),
          ),
        ),
      ],
      onChanged: (val) => setState(() => _selectedParentDept = val),
    );
  }

  // ── UI Helpers ────────────────────────────────────────────────────────────

  Widget _buildStepHeader(String step, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.primary,
            child: Text(
              step,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
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

  Widget _buildSubmitButton(List<DepartmentEntity> departments) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _onSubmit(departments),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          "TẠO PHÒNG BAN",
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
