import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/deparment/department_list_bloc.dart';
import 'package:my_app/ui/deparment/department_list_event.dart';
import 'package:my_app/ui/deparment/department_list_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<DepartmentEntity> _allDepartments = [];

  @override
  void initState() {
    super.initState();
    context.read<DepartmentListBloc>().add(GetDepartments());
    _searchController.addListener(() {
      setState(
        () => _searchQuery = _searchController.text.trim().toLowerCase(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DepartmentEntity> get _filtered {
    if (_searchQuery.isEmpty) return _allDepartments;
    return _allDepartments
        .where(
          (d) =>
              (d.deptName ?? '').toLowerCase().contains(_searchQuery) ||
              d.id.toString() == _searchQuery,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const TrText(
          "Đơn vị & Phòng ban",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => context.push('/create-department'),
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 28,
              ),
              tooltip: "Thêm đơn vị mới",
            ),
          ),
        ],
      ),
      body: BlocConsumer<DepartmentListBloc, DepartmentListState>(
        listener: (context, state) {
          if (state is DepartmentListLoaded) {
            setState(() => _allDepartments = state.departments);
          }
        },
        builder: (context, state) {
          if (state is DepartmentListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DepartmentListError) {
            return _buildErrorState(state.message);
          }
          return Column(
            children: [
              _buildSearchSection(),
              Expanded(
                child: _filtered.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => _buildCard(_filtered[i]),
                      )
                    : _buildEmptyState(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: uiText(context, "Tìm kiếm mã hoặc tên đơn vị..."),
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(DepartmentEntity dept) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 5, color: AppColors.primary.withOpacity(0.6)),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/department-detail/${dept.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrText(
                              "Mã đơn vị: #${dept.id}",
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: Color(0xFFCBD5E1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TrText(
                          dept.deptName ?? 'Không tên',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (dept.locationDesc != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TrText(
                                  dept.locationDesc!,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const Divider(height: 24, thickness: 0.5),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_alt_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            TrText(
                              "${dept.usersCount ?? 0} nhân sự",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const TrText(
                              "Chi tiết",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
            message,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<DepartmentListBloc>().add(GetDepartments()),
            child: const TrText('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 60,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const TrText(
            "Không tìm thấy đơn vị phù hợp",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
          ),
        ],
      ),
    );
  }
}
