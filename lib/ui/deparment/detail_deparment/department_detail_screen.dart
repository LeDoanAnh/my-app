import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/data/model/asset_model.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_bloc.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_event.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class DepartmentDetailScreen extends StatefulWidget {
  final int departmentId;
  const DepartmentDetailScreen({super.key, required this.departmentId});

  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DepartmentDetailBloc>().add(
      GetDepartmentDetail(widget.departmentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => context.pop(),
        ),
        title: const TrText(
          "Chi tiết Đơn vị",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<DepartmentDetailBloc, DepartmentDetailState>(
        builder: (context, state) {
          if (state is DepartmentDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DepartmentDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  TrText(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DepartmentDetailBloc>().add(
                      GetDepartmentDetail(widget.departmentId),
                    ),
                    child: const TrText('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (state is DepartmentDetailLoaded) {
            return _buildBody(state.department);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBody(DepartmentEntity dept) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(dept),
          const SizedBox(height: 20),

          _buildSectionTitle("THÔNG TIN ĐƠN VỊ"),
          _buildInfoCard([
            _buildInfoRow(
              Icons.business_rounded,
              "Tên phòng ban",
              dept.deptName ?? 'Chưa cập nhật',
            ),
            _buildInfoRow(
              Icons.account_tree_outlined,
              "Đơn vị cấp trên",
              dept.parent?.deptName ?? 'Không có',
            ),
            _buildInfoRow(
              Icons.description_outlined,
              "Mô tả vị trí",
              dept.locationDesc ?? 'Chưa cập nhật',
            ),
          ]),
          const SizedBox(height: 20),

          // Locations
          if (dept.locations != null && dept.locations!.isNotEmpty) ...[
            _buildSectionTitle("VỊ TRÍ & CƠ SỞ VẬT CHẤT"),
            _buildInfoCard(
              dept.locations!
                  .map(
                    (l) => Column(
                      children: [
                        _buildDetailTile("Tên khu vực", l.locationName ?? '-'),
                        _buildDetailTile("Sức chứa tối đa", l.capacity ?? '-'),
                        _buildDetailTile(
                          "Trạng thái",
                          l.status ?? '-',
                          isStatus: true,
                        ),
                        if (dept.locations!.last != l)
                          const Divider(height: 16),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Assets
          if (dept.assets != null && dept.assets!.isNotEmpty) ...[
            _buildSectionTitle("DANH MỤC TÀI SẢN QUẢN LÝ"),
            _buildInfoCard([
              ...dept.assets!.map(
                (a) => _buildAssetRow(
                  a.assetCode ?? '-',
                  a.assetName ?? '-',
                  '${a.unit ?? ''}',
                ),
              ),
              const Divider(height: 20),
              GestureDetector(
                onTap: () {},
                child: Center(
                  child: TrText(
                    "Xem tất cả ${dept.assetsCount ?? 0} tài sản",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
          ],

          // Users
          if (dept.users != null && dept.users!.isNotEmpty) ...[
            _buildSectionTitle("DANH SÁCH NHÂN SỰ"),
            _buildInfoCard(
              dept.users!.take(5).map((u) => _buildUserRow(u)).toList()..add(
                dept.users!.length > 5
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                          child: TrText(
                            "Xem thêm...",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStats(DepartmentEntity dept) {
    return Row(
      children: [
        _statBox("Nhân sự", '${dept.usersCount ?? 0}', Colors.blue),
        const SizedBox(width: 10),
        _statBox("Tài sản", '${dept.assetsCount ?? 0}', Colors.orange),
        const SizedBox(width: 10),
        _statBox("Tờ trình", '${dept.submissionsCount ?? 0}', Colors.green),
      ],
    );
  }

  Widget _buildUserRow(UserModel u) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: TrText(
              (u.fullName ?? '?')[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(
                  u.fullName ?? '-',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TrText(
                  u.email ?? '-',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: u.status == 'active'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: TrText(
              u.status == 'active' ? 'Hoạt động' : 'Khóa',
              style: TextStyle(
                fontSize: 10,
                color: u.status == 'active' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: TrText(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.blueGrey,
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _buildInfoCard(List<Widget> children) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );

  Widget _buildInfoRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrText(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              TrText(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildDetailTile(
    String label,
    String value, {
    bool isStatus = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TrText(
          label,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
        ),
        TrText(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isStatus ? Colors.green : AppColors.textDark,
          ),
        ),
      ],
    ),
  );

  Widget _buildAssetRow(String code, String name, String unit) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        TrText(
          code,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TrText(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        TrText(
          unit,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );

  Widget _statBox(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          TrText(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          TrText(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
