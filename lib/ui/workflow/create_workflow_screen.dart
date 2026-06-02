import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';

class CreateWorkflowScreen extends StatefulWidget {
  const CreateWorkflowScreen({super.key});

  @override
  State<CreateWorkflowScreen> createState() => _CreateWorkflowScreenState();
}

class _CreateWorkflowScreenState extends State<CreateWorkflowScreen> {
  final List<Map<String, dynamic>> _allDepts = [
    {"id": null, "name": "Tất cả đơn vị (Luồng khung chung)"},
    {"id": 34, "name": "CLB Tình nguyện"},
    {"id": 35, "name": "CLB Kỹ năng"},
    {"id": 5, "name": "Văn phòng Đoàn"},
    {"id": 2, "name": "Hội Sinh viên"},
    {"id": 1, "name": "Ban Giám hiệu"},
  ];

  // --- CONTROLLERS ---
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDesController = TextEditingController();

  // --- STATE ---
  int? _selectedApplyDeptId;
  String _selectedApplyDeptName = "Tất cả đơn vị";
  List<Map<String, dynamic>> _steps = [];

  @override
  void initState() {
    super.initState();
    _addNewStep(); // Mặc định có sẵn 1 bước khi vào màn hình
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDesController.dispose();
    super.dispose();
  }

  // Thêm bước duyệt mới với Role mặc định là 3
  void _addNewStep() {
    setState(() {
      _steps.add({
        "step_order": _steps.length + 1,
        "target_dept_id": null,
        "target_dept_name": "Đơn vị của người gửi (Tự động)",
        "target_role_id": 3,
        "target_role_name": "Trưởng phòng/Phó phòng",
      });
    });
  }

  void _showPicker({
    required String title,
    required List<Map<String, dynamic>> data,
    required Function(Map<String, dynamic>) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
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
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) => ListTile(
                  title: Text(
                    data[i]['name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    onSelect(data[i]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          "Cấu hình Loại đơn & Luồng duyệt",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildTimelineSection(),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: _buildFooterAction(),
    );
  }

  // --- PHẦN 1: NHẬP THÔNG TIN CATEGORY ---
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
          const Text(
            "THÔNG TIN LOẠI ĐƠN MỚI",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _categoryNameController,
            label: "Tên loại tờ trình",
            hint: "VD: Tổ chức sự kiện, Mượn hội trường...",
            icon: Icons.edit_note_outlined,
          ),
          const SizedBox(height: 12),
          _buildInputField(
            controller: _categoryDesController,
            label: "Mô tả nội dung khung",
            hint: "Tờ trình này dùng cho mục đích gì...",
            icon: Icons.description_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _buildSelectTile(
            label: "Áp dụng cho đơn vị",
            value: _selectedApplyDeptName,
            icon: Icons.account_balance_outlined,
            onTap: () => _showPicker(
              title: "Chọn Đơn Vị Áp Dụng",
              data: _allDepts,
              onSelect: (item) => setState(() {
                _selectedApplyDeptId = item['id'];
                _selectedApplyDeptName = item['name'];
              }),
            ),
          ),
        ],
      ),
    );
  }

  // --- PHẦN 2: TIMELINE LUỒNG DUYỆT ---
  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "QUY TRÌNH DUYỆT (ROLE 3 BẮT BUỘC)",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          ..._steps
              .asMap()
              .entries
              .map((entry) => _buildStepItem(entry.key))
              .toList(),
          _buildAddStepButton(),
        ],
      ),
    );
  }

  Widget _buildStepItem(int index) {
    var step = _steps[index];
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
                    "${index + 1}",
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
                  color: AppColors.primary.withOpacity(0.2),
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
                    color: Colors.black.withOpacity(0.03),
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
                        "Đơn vị phê duyệt",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      if (index > 0)
                        GestureDetector(
                          onTap: () => setState(() => _steps.removeAt(index)),
                          child: const Icon(
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
                      title: "Chọn Đơn Vị Duyệt",
                      data: [
                        {"id": null, "name": "Đơn vị người gửi (Tự động)"},
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
                    "Chức vụ phê duyệt (Mặc định)",
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
                      Text(
                        step['target_role_name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
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
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                "Thêm bước duyệt",
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

  Widget _buildFooterAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Gửi dữ liệu về Server
          final data = {
            "category_name": _categoryNameController.text,
            "description": _categoryDesController.text,
            "apply_for_dept_id": _selectedApplyDeptId,
            "workflow_steps": _steps, // Mỗi bước đều có target_role_id = 3
          };
          print("DỮ LIỆU GỬI ĐI: $data");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Lưu Loại đơn & Luồng duyệt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---

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
            Column(
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
                ),
              ],
            ),
            const Spacer(),
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
              ),
            ),
            const Icon(Icons.unfold_more, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
