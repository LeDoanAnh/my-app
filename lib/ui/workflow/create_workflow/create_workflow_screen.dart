import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/approval_step_entity.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_bloc.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_event.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_state.dart';

class CreateWorkflowScreen extends StatefulWidget {
  final int? workflowId;

  const CreateWorkflowScreen({super.key, this.workflowId});

  @override
  State<CreateWorkflowScreen> createState() => _CreateWorkflowScreenState();
}

class _CreateWorkflowScreenState extends State<CreateWorkflowScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDesController = TextEditingController();

  List<Map<String, dynamic>> _allDepts = [
    {'id': null, 'name': 'Tất cả đơn vị (Luồng khung chung)'},
  ];
  int? _selectedApplyDeptId;
  String _selectedApplyDeptName = 'Tất cả đơn vị';
  String _status = 'active';
  List<Map<String, dynamic>> _steps = [];
  bool _hydrated = false;

  bool get _isEditMode => widget.workflowId != null;

  @override
  void initState() {
    super.initState();
    context.read<CreateWorkflowBloc>().add(
      LoadCreateWorkflow(workflowId: widget.workflowId),
    );
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDesController.dispose();
    super.dispose();
  }

  void _hydrateForm(CreateWorkflowReady state) {
    if (_hydrated) return;

    setState(() {
      _allDepts = [
        {'id': null, 'name': 'Tất cả đơn vị (Luồng khung chung)'},
        ...state.departments.map(_departmentToPickerItem),
      ];

      final workflow = state.workflow;
      if (workflow != null) {
        _categoryNameController.text = workflow.categoryName ?? '';
        _categoryDesController.text = workflow.description ?? '';
        _selectedApplyDeptId = workflow.applyForDeptId;
        _selectedApplyDeptName = workflow.applyForDept ?? 'Tất cả đơn vị';
        _status = workflow.status == 'inactive' ? 'inactive' : 'active';
        _steps = _mapSteps(workflow);
      }

      if (_steps.isEmpty) {
        _steps.add(_newStep());
      }
      _hydrated = true;
    });
  }

  Map<String, dynamic> _departmentToPickerItem(DepartmentEntity department) {
    return {
      'id': department.id,
      'name': department.deptName ?? 'Đơn vị #${department.id}',
    };
  }

  List<Map<String, dynamic>> _mapSteps(ApprovalStepEntity workflow) {
    return (workflow.approvalSteps ?? [])
        .map(
          (step) => {
            'step_order': step.stepOrder ?? 1,
            'target_dept_id': step.deptId,
            'target_dept_name':
                step.targetDeptName ??
                step.desc ??
                'Đơn vị của người gửi (Tự động)',
            'target_role_id': step.targetRoleId ?? 3,
            'target_role_name': step.role ?? 'Trưởng phòng/Phó phòng',
          },
        )
        .toList();
  }

  Map<String, dynamic> _newStep() {
    return {
      'step_order': _steps.length + 1,
      'target_dept_id': null,
      'target_dept_name': 'Đơn vị của người gửi (Tự động)',
      'target_role_id': 3,
      'target_role_name': 'Trưởng phòng/Phó phòng',
    };
  }

  void _addNewStep() {
    setState(() => _steps.add(_newStep()));
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      _renumberSteps();
    });
  }

  void _renumberSteps() {
    for (var i = 0; i < _steps.length; i++) {
      _steps[i]['step_order'] = i + 1;
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final categoryName = _categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      _showSnackBar('Vui lòng nhập tên loại tờ trình', isError: true);
      return;
    }

    if (_steps.isEmpty) {
      _showSnackBar('Vui lòng thêm ít nhất một bước duyệt', isError: true);
      return;
    }

    _renumberSteps();
    final body = {
      'category_name': categoryName,
      'description': _categoryDesController.text.trim(),
      'apply_for_dept_id': _selectedApplyDeptId,
      'status': _status,
      'workflow_steps': _steps
          .map(
            (step) => {
              'step_order': step['step_order'],
              'target_dept_id': step['target_dept_id'],
              'target_role_id': step['target_role_id'] ?? 3,
            },
          )
          .toList(),
    };

    context.read<CreateWorkflowBloc>().add(
      SubmitCreateWorkflow(workflowId: widget.workflowId, body: body),
    );
  }

  void _showPicker({
    required String title,
    required List<Map<String, dynamic>> data,
    required ValueChanged<Map<String, dynamic>> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    data[index]['name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    onSelect(data[index]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateWorkflowBloc, CreateWorkflowState>(
      listener: (context, state) {
        if (state is CreateWorkflowReady) {
          _hydrateForm(state);
        } else if (state is CreateWorkflowSuccess) {
          _showSnackBar(state.message);
          context.pop(true);
        } else if (state is CreateWorkflowError) {
          _showSnackBar(state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading =
            state is CreateWorkflowInitial || state is CreateWorkflowLoading;
        final isSaving = state is CreateWorkflowSaving;

        return Scaffold(
          backgroundColor: AppColors.scaffold,
          appBar: AppBar(
            title: Text(
              _isEditMode ? 'Sửa luồng duyệt' : 'Thêm luồng duyệt',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 24),
                      _buildTimelineSection(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
          bottomSheet: isLoading ? null : _buildFooterAction(isSaving),
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditMode ? 'THÔNG TIN LUỒNG DUYỆT' : 'THÔNG TIN LOẠI TỜ TRÌNH',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _categoryNameController,
            label: 'Tên loại tờ trình',
            hint: 'VD: Tổ chức sự kiện, mượn hội trường...',
            icon: Icons.edit_note_outlined,
          ),
          const SizedBox(height: 12),
          _buildInputField(
            controller: _categoryDesController,
            label: 'Mô tả nội dung khung',
            hint: 'Tờ trình này dùng cho mục đích gì...',
            icon: Icons.description_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _buildSelectTile(
            label: 'Áp dụng cho đơn vị',
            value: _selectedApplyDeptName,
            icon: Icons.account_balance_outlined,
            onTap: () => _showPicker(
              title: 'Chọn đơn vị áp dụng',
              data: _allDepts,
              onSelect: (item) => setState(() {
                _selectedApplyDeptId = item['id'];
                _selectedApplyDeptName = item['id'] == null
                    ? 'Tất cả đơn vị'
                    : item['name'];
              }),
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusSelector(),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    final isActive = _status == 'active';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.play_circle_outline : Icons.pause_circle,
                color: isActive ? AppColors.success : AppColors.textGrey,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Trạng thái luồng duyệt',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatusOption(
                  title: 'Đang hoạt động',
                  selected: isActive,
                  onTap: () => setState(() => _status = 'active'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusOption(
                  title: 'Không hoạt động',
                  selected: !isActive,
                  onTap: () => setState(() => _status = 'inactive'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUY TRÌNH DUYỆT (ROLE 3 BẮT BUỘC)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          ..._steps.asMap().entries.map((entry) => _buildStepItem(entry.key)),
          _buildAddStepButton(),
        ],
      ),
    );
  }

  Widget _buildStepItem(int index) {
    final step = _steps[index];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Đơn vị phê duyệt',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      if (index > 0)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _removeStep(index),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                  _buildMiniPicker(
                    value: step['target_dept_name'],
                    onTap: () => _showPicker(
                      title: 'Chọn đơn vị duyệt',
                      data: [
                        {'id': null, 'name': 'Đơn vị của người gửi (Tự động)'},
                        ..._allDepts.where((d) => d['id'] != null),
                      ],
                      onSelect: (item) => setState(() {
                        _steps[index]['target_dept_id'] = item['id'];
                        _steps[index]['target_dept_name'] = item['name'];
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chức vụ phê duyệt',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step['target_role_name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStepButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 44, bottom: 20),
      child: InkWell(
        onTap: _addNewStep,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Thêm bước duyệt',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterAction(bool isSaving) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isSaving ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.textGrey,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _isEditMode ? 'Cập nhật luồng duyệt' : 'Lưu luồng duyệt',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  fontSize: 10,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPicker({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.unfold_more, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
