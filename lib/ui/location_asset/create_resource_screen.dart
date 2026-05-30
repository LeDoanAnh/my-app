import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';
import 'package:my_app/ui/location_asset/form_resource_bloc.dart';
import 'package:my_app/ui/location_asset/form_resource_event.dart';
import 'package:my_app/ui/location_asset/form_resource_state.dart';

class CreateResourceScreen extends StatefulWidget {
  const CreateResourceScreen({super.key});

  @override
  State<CreateResourceScreen> createState() => _CreateResourceScreenState();
}

class _CreateResourceScreenState extends State<CreateResourceScreen> {
  final _formKey = GlobalKey<FormState>();

  String _resourceType = "asset";

  final _nameController = TextEditingController();
  DepartmentEntity? _selectedDept;

  final _assetCodeController = TextEditingController();
  final _unitController = TextEditingController();
  String _selectedAssetMode = "returnable";

  final _capacityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FormResourceBloc>().add(GetDepartmentList());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _assetCodeController.dispose();
    _unitController.dispose();
    _capacityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSubmit(List<DepartmentEntity> departments) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDept == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn đơn vị phụ trách")),
        );
        return;
      }

      final confirmContent = _resourceType == "asset"
          ? "Tạo vật tư \"${_nameController.text.trim()}\" "
                "(${_selectedAssetMode == 'returnable' ? 'Mượn trả' : 'Tiêu hao'}) "
                "thuộc ${_selectedDept!.deptName}?"
          : "Tạo địa điểm \"${_nameController.text.trim()}\" "
                "thuộc ${_selectedDept!.deptName}?";

      showDialog(
        context: context,
        builder: (_) => AppConfirmationDialog(
          title: _resourceType == "asset"
              ? "Xác nhận tạo vật tư"
              : "Xác nhận tạo địa điểm",
          content: confirmContent,
          confirmText: "Tạo",
          cancelText: "Kiểm tra lại",
          icon: _resourceType == "asset"
              ? Icons.inventory_2_rounded
              : Icons.location_on_rounded,
          onConfirm: () {
            if (_resourceType == "asset") {
              context.read<FormResourceBloc>().add(
                SubmitCreateAsset(
                  name: _nameController.text.trim(),
                  description: _assetCodeController.text.trim(),
                  unit: _unitController.text.trim(),
                  assetType: _selectedAssetMode,
                  deptId: _selectedDept!.id,
                ),
              );
            } else {
              context.read<FormResourceBloc>().add(
                SubmitCreateLocation(
                  name: _nameController.text.trim(),
                  capacity: _capacityController.text.trim(),
                  address: _addressController.text.trim(),
                  deptId: _selectedDept!.id,
                ),
              );
            }
          },
        ),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _assetCodeController.clear();
    _unitController.clear();
    _capacityController.clear();
    _addressController.clear();
    setState(() {
      _selectedDept = null;
      _selectedAssetMode = "returnable";
    });
    context.read<FormResourceBloc>().add(GetDepartmentList());
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tạo thành công!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Tạo tiếp",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Hoàn tất & Thoát",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormResourceBloc, FormResourceState>(
      listener: (context, state) {
        if (state is FormResourceSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is FormResourceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
          // Reload lại departments sau lỗi
          context.read<FormResourceBloc>().add(GetDepartmentList());
        }
      },
      builder: (context, state) {
        List<DepartmentEntity> departments = [];
        bool isDeptLoading = true;

        if (state is FormResourceLoaded) {
          departments = state.departments;
          isDeptLoading = false;
        } else if (state is FormResourceLoading) {
          isDeptLoading = false; // Đang submit, dept đã có rồi
        }

        return Scaffold(
          backgroundColor: AppColors.fieldBg,
          appBar: AppBar(
            title: const Text(
              "Thêm mới CSVC",
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textDark,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: state is FormResourceLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypeToggle(),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(
                                _resourceType == "asset"
                                    ? "Tên vật tư / Tài sản"
                                    : "Tên địa điểm / Phòng",
                              ),
                              _buildTextField(
                                _nameController,
                                "VD: Máy chiếu Sony V5",
                                Icons.drive_file_rename_outline_rounded,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? "Vui lòng nhập tên"
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              if (_resourceType == "asset") ...[
                                _buildLabel("Chế độ quản lý"),
                                _buildSlidingToggle(),
                                const SizedBox(height: 20),

                                _buildLabel("Mã định danh (Asset Code)"),
                                _buildTextField(
                                  _assetCodeController,
                                  "VD: MS-001",
                                  Icons.qr_code_2_rounded,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Vui lòng nhập mã"
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                _buildLabel("Đơn vị tính (Unit)"),
                                _buildTextField(
                                  _unitController,
                                  "VD: Cái, Thùng, Bộ",
                                  Icons.straighten_rounded,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Vui lòng nhập đơn vị"
                                      : null,
                                ),
                                const SizedBox(height: 20),
                              ],

                              if (_resourceType == "location") ...[
                                _buildLabel("Địa chỉ"),
                                _buildTextField(
                                  _addressController,
                                  "VD: Phòng 1008, Tòa A2",
                                  Icons.location_on_outlined,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Vui lòng nhập địa chỉ"
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                _buildLabel("Sức chứa (Người)"),
                                _buildTextField(
                                  _capacityController,
                                  "VD: 100",
                                  Icons.groups_outlined,
                                  isNumber: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Vui lòng nhập sức chứa"
                                      : null,
                                ),
                                const SizedBox(height: 20),
                              ],

                              _buildLabel("Đơn vị phụ trách"),
                              isDeptLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : _buildDeptDropdown(departments),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
          bottomSheet: state is FormResourceLoading
              ? null
              : _buildBottomButton(departments),
        );
      },
    );
  }

  // ── Dropdown phòng ban thật ──────────────────────────────────────────────

  Widget _buildDeptDropdown(List<DepartmentEntity> departments) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DepartmentEntity>(
          value: _selectedDept,
          hint: Text(
            "Chọn phòng ban...",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          isExpanded: true,
          items: departments
              .map(
                (dept) => DropdownMenuItem(
                  value: dept,
                  child: Text(
                    dept.deptName ?? "Không rõ",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedDept = val),
        ),
      ),
    );
  }

  // ── Giữ nguyên toàn bộ widget cũ ────────────────────────────────────────

  Widget _buildTypeToggle() {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTypeBtn("Vật tư", "asset"),
          _buildTypeBtn("Địa điểm", "location"),
        ],
      ),
    );
  }

  Widget _buildTypeBtn(String label, String type) {
    bool isSel = _resourceType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _resourceType = type),
        child: Container(
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSel ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlidingToggle() {
    bool isReturnable = _selectedAssetMode == "returnable";
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: isReturnable
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selectedAssetMode = "returnable"),
                  child: Center(
                    child: Text(
                      "Mượn trả",
                      style: TextStyle(
                        color: isReturnable ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selectedAssetMode = "consumable"),
                  child: Center(
                    child: Text(
                      "Tiêu hao",
                      style: TextStyle(
                        color: !isReturnable ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: ctrl,
        validator: validator,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          icon: Icon(icon, color: AppColors.primary, size: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBottomButton(List<DepartmentEntity> departments) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ElevatedButton(
        onPressed: () => _onSubmit(departments),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: const Text(
          "XÁC NHẬN TẠO",
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
