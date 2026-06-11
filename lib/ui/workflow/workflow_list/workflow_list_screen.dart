import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/workflow_list_entity.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_bloc.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_event.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_state.dart';

class WorkflowListScreen extends StatefulWidget {
  const WorkflowListScreen({super.key});

  @override
  State<WorkflowListScreen> createState() => _WorkflowListScreenState();
}

class _WorkflowListScreenState extends State<WorkflowListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkflowListBloc>().add(GetWorkflowList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const Text(
          "Cấu hình Luồng duyệt",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () async {
              final result = await context.push<bool>('/create-workflow');
              if (!context.mounted || result != true) return;
              context.read<WorkflowListBloc>().add(GetWorkflowList());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<WorkflowListBloc, WorkflowListState>(
        builder: (context, state) {
          if (state is WorkflowListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkflowListLoaded) {
            final workflows = state.workflows;
            if (workflows.isEmpty) {
              return const Center(child: Text("Chưa có quy trình nào"));
            }
            return Column(
              children: [
                _SummaryHeader(workflows: workflows),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: workflows.length,
                    itemBuilder: (context, index) => _WorkflowCard(
                      wf: workflows[index],
                      onChanged: () => context.read<WorkflowListBloc>().add(
                        GetWorkflowList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is WorkflowListError) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Tách widget nhỏ — không rebuild toàn màn hình ─────────────────

class _SummaryHeader extends StatelessWidget {
  final List<WorkflowListEntity> workflows;

  const _SummaryHeader({required this.workflows});

  @override
  Widget build(BuildContext context) {
    final activeCount = workflows.where((w) => w.status == 'active').length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(
            Icons.account_tree_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            "Đang hoạt động: $activeCount quy trình",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  final WorkflowListEntity wf;
  final VoidCallback onChanged;

  const _WorkflowCard({required this.wf, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isActive = wf.status == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            final result = await context.push<bool>(
              '/workflow-detail/${wf.id}',
            );
            if (result == true) {
              onChanged();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          (isActive ? AppColors.primary : Colors.grey)
                              .withValues(alpha: 0.1),
                      child: Icon(
                        Icons.alt_route_rounded,
                        color: isActive ? AppColors.primary : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wf.name ?? "Không tên",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Áp dụng: ${wf.applyTo ?? 'N/A'}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(isActive: isActive),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                color: AppColors.fieldBg.withValues(alpha: 0.5),
                child: Row(
                  children: [
                    const Text(
                      "QUY TRÌNH:",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: _buildStepItems(wf.steps ?? [])),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStepItems(List<String> steps) {
    final items = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      items.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            steps[i],
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      );
      if (i < steps.length - 1) {
        items.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.keyboard_double_arrow_right_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ),
        );
      }
    }
    return items;
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "ON" : "OFF",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
