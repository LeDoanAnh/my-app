// ui/in_out/asset_submission/asset_submission_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';
import 'package:my_app/ui/in_out/asset_submission/asset_detail/asset_task_bloc.dart';
import 'package:my_app/l10n/ui_text.dart';

class AssetSubmissionListScreen extends StatefulWidget {
  final int handlerId;
  final int deptId;
  const AssetSubmissionListScreen({
    super.key,
    required this.deptId,
    required this.handlerId,
  });

  @override
  State<AssetSubmissionListScreen> createState() =>
      _AssetSubmissionListScreenState();
}

class _AssetSubmissionListScreenState extends State<AssetSubmissionListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AssetTaskBloc>().add(LoadAssetTasks(deptId: widget.deptId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<AssetTaskBloc>().add(
      LoadAssetTasks(
        deptId: widget.deptId,
        search: query.isEmpty ? null : query,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const TrText(
          "Danh sách đơn vật tư",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<AssetTaskBloc, AssetTaskState>(
              builder: (context, state) {
                if (state is AssetTaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AssetTaskError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        TrText(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<AssetTaskBloc>().add(
                            LoadAssetTasks(deptId: widget.deptId),
                          ),
                          child: const TrText("Thử lại"),
                        ),
                      ],
                    ),
                  );
                }
                if (state is AssetTaskLoaded) {
                  if (state.tasks.isEmpty) return _buildEmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) =>
                        _buildAssetItem(context, state.tasks[index]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: uiText(context, "Tìm mã đơn hoặc tên vật tư..."),
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: const Color(0xFFF1F3F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAssetItem(BuildContext context, AssetTaskEntity task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            context.push(
              '/asset-submission-detail',
              extra: {
                'submissionId': task.id,
                'deptId': widget.deptId,
                'handlerId': widget.handlerId,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TrText(
                        "#${task.id}",
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TrText(
                      task.date ?? "-",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TrText(
                  task.title ?? "Không có tiêu đề",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                if (task.sender != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 13,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TrText(
                          task.sender!,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),

                // Người duyệt
                if (task.approvedBy != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 13,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        TrText(
                          "Duyệt bởi: ${task.approvedBy!.name ?? '-'}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 6),
                        TrText(
                          "${task.itemCount ?? 0} vật phẩm",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 12,
                            color: Color(0xFF10B981),
                          ),
                          SizedBox(width: 4),
                          TrText(
                            "Đã duyệt",
                            style: TextStyle(
                              color: Color(0xFF065F46),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          TrText(
            "Không tìm thấy đơn vật tư nào",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
