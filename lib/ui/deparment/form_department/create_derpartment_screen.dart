import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/deparment/form_department/form_department_bloc.dart';
import 'package:my_app/ui/deparment/form_department/form_department_event.dart';
import 'package:my_app/ui/deparment/form_department/form_department_state.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final DepartmentEntity? initialDepartment;

  const CreateDepartmentScreen({super.key, this.initialDepartment});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deptNameController = TextEditingController();
  final TextEditingController _locationDescController = TextEditingController();

  DepartmentEntity? _selectedParentDept;
  String _status = 'active';
  bool _hydrated = false;

  bool get _isEditMode => widget.initialDepartment != null;

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

  void _hydrate(List<DepartmentEntity> departments) {
    if (_hydrated || widget.initialDepartment == null) return;

    final department = widget.initialDepartment!;
    _deptNameController.text = department.deptName ?? '';
    _locationDescController.text = department.locationDesc ?? '';
    _status = department.status == 'inactive' ? 'inactive' : 'active';
    _selectedParentDept = departments
        .where((item) => item.id == department.parentDeptId)
        .cast<DepartmentEntity?>()
        .firstOrNull;
    _hydrated = true;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final deptName = _deptNameController.text.trim();
    final locationDesc = _locationDescController.text.trim();

    if (_isEditMode) {
      context.read<FormDepartmentBloc>().add(
        SubmitUpdateDepartment(
          id: widget.initialDepartment!.id,
          deptName: deptName,
          locationDesc: locationDesc,
          parentDeptId: _selectedParentDept?.id,
          status: _status,
        ),
      );
      return;
    }

    context.read<FormDepartmentBloc>().add(
      SubmitCreateDepartment(
        deptName: deptName,
        locationDesc: locationDesc,
        parentDeptId: _selectedParentDept?.id,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Sửa đơn vị' : 'Tạo đơn vị mới',
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
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

          final departments = state is FormDepartmentLoaded
              ? state.departments
              : <DepartmentEntity>[];
          _hydrate(departments);

          final parentOptions = departments
              .where((item) => item.id != widget.initialDepartment?.id)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thiết lập thông tin đơn vị và trạng thái hoạt động.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  _buildSection([
                    _buildInputField(
                      controller: _deptNameController,
                      hint: 'Tên đơn vị',
                      icon: Icons.business_rounded,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Vui lòng nhập tên đơn vị'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _locationDescController,
                      hint: 'Vị trí / địa chỉ',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildDepartmentDropdown(parentOptions),
                    const SizedBox(height: 12),
                    _buildStatusSelector(),
                  ]),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isEditMode ? 'CẬP NHẬT ĐƠN VỊ' : 'TẠO ĐƠN VỊ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
      ),
    );
  }

  Widget _buildDepartmentDropdown(List<DepartmentEntity> departments) {
    return DropdownButtonFormField<DepartmentEntity>(
      initialValue: _selectedParentDept,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.account_tree_outlined,
          size: 20,
          color: AppColors.primary,
        ),
        hintText: 'Trực thuộc đơn vị',
        filled: true,
        fillColor: AppColors.fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        const DropdownMenuItem<DepartmentEntity>(
          value: null,
          child: Text('Không có (đơn vị gốc)'),
        ),
        ...departments.map(
          (department) => DropdownMenuItem<DepartmentEntity>(
            value: department,
            child: Text(department.deptName ?? 'Không rõ'),
          ),
        ),
      ],
      onChanged: (value) => setState(() => _selectedParentDept = value),
    );
  }

  Widget _buildStatusSelector() {
    final isActive = _status == 'active';
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Đang hoạt động',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        isActive ? 'Đơn vị có thể được sử dụng' : 'Dữ liệu vẫn được giữ lại',
      ),
      value: isActive,
      activeThumbColor: AppColors.primary,
      onChanged: (value) =>
          setState(() => _status = value ? 'active' : 'inactive'),
    );
  }
}
