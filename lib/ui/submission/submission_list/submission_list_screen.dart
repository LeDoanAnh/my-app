import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_bloc.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_event.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_state.dart';

class SubmissionListScreen extends StatefulWidget {
  final UserEntity user;

  const SubmissionListScreen({super.key, required this.user});

  @override
  State<SubmissionListScreen> createState() => _SubmissionListScreenState();
}

class _SubmissionListScreenState extends State<SubmissionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    context.read<SubmissionListBloc>().add(
      FetchSubmissionList(
        userId: widget.user.id,
        roles: widget.user.roles ?? [],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isApprover = widget.user.roles!.any((role) => role.id == 3);
    final tabCount = isApprover ? 4 : 3;

    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        backgroundColor: AppColors.fieldBg,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Danh sách tờ đơn',
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                _buildSearchBar(),
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textGrey,
                  indicatorColor: AppColors.primary,
                  isScrollable: isApprover,
                  tabs: [
                    Tab(text: 'Đang chờ'),
                    Tab(text: 'Đã duyệt'),
                    Tab(text: 'Từ chối'),
                    if (isApprover) Tab(text: 'Cần duyệt'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<SubmissionListBloc, SubmissionListState>(
          builder: (context, state) {
            if (state is SubmissionListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubmissionListError) {
              return RefreshIndicator(
                onRefresh: () async => _refreshData(),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            if (state is SubmissionListLoaded) {
              return TabBarView(
                children: [
                  _buildListByStatus(state.mySubmissions, 'pending'),
                  _buildListByStatus(state.mySubmissions, 'approved'),
                  _buildListByStatus(state.mySubmissions, 'rejected'),
                  if (isApprover)
                    _buildListByStatus(
                      state.pendingApproval ?? [],
                      'waiting_for_me',
                      isApproverTab: true,
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchKeyword = value),
          decoration: InputDecoration(
            hintText: 'Tìm mã đơn hoặc tiêu đề...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildListByStatus(
    List<SubmissionEntity> data,
    String statusCode, {
    bool isApproverTab = false,
  }) {
    final filteredList = data.where((item) {
      final matchesStatus =
          item.statusCode?.toLowerCase() == statusCode.toLowerCase();
      final matchesSearch =
          (item.submissionCode?.toLowerCase() ?? '').contains(
            _searchKeyword.toLowerCase(),
          ) ||
          (item.title?.toLowerCase() ?? '').contains(
            _searchKeyword.toLowerCase(),
          );
      return matchesStatus && matchesSearch;
    }).toList();

    Future<void> handleRefresh() async {
      _refreshData();
      await context.read<SubmissionListBloc>().stream.firstWhere(
        (state) =>
            state is SubmissionListLoaded || state is SubmissionListError,
      );
    }

    if (filteredList.isEmpty) {
      return RefreshIndicator(
        onRefresh: handleRefresh,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: Text(
              'Không có dữ liệu cho mục này',
              style: TextStyle(color: AppColors.textGrey.withOpacity(0.8)),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: handleRefresh,
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) =>
            _buildSubmissionCard(filteredList[index], isApproverTab),
      ),
    );
  }

  Widget _buildSubmissionCard(SubmissionEntity item, bool isApproverTab) {
    Color statusColor;
    switch (item.statusCode?.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.success;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        break;
      case 'pending':
      case 'waiting_for_me':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.textGrey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          if (isApproverTab && item.statusCode == 'waiting_for_me') {
            final result = await context.push<bool>(
              '/approver-decision',
              extra: {
                'submissionId': item.id,
                'deptId': widget.user.departmentId ?? 1,
                'approverId': widget.user.id,
              },
            );
            if (mounted && result == true) {
              _refreshData();
            }
          } else {
            context.push('/submission-detail/${item.id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.submissionCode ?? 'N/A',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(item.date),
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title ?? 'Không có tiêu đề',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isApproverTab ? Icons.person : Icons.how_to_reg,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isApproverTab
                          ? '${'Người tạo'}: ${item.creatorName}'
                          : '${'Người duyệt'}: ${item.approverName ?? 'Đang chờ'}',
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.categoryName ?? 'Loại đơn',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.status ?? 'N/A',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return dateStr.split('T')[0];
    }
  }
}
