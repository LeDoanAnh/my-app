import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/actor_entity.dart';
import 'package:my_app/ui/user/actor_list/actor_list_bloc.dart';
import 'package:my_app/ui/user/actor_list/actor_list_event.dart';
import 'package:my_app/ui/user/actor_list/actor_list_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchKeyword = "";
  String _statusFilter = 'Tất cả';
  String _deptFilter = 'Tất cả đơn vị';

  @override
  void initState() {
    super.initState();
    context.read<ActorListBloc>().add(GetActorListEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const Text(
          "Quản lý tài khoản",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => context.push('/create-user'), // ← go_router
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<ActorListBloc, ActorListState>(
        builder: (context, state) {
          if (state is ActorListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ActorListLoaded) {
            final deptOptions = [
              "Tất cả đơn vị",
              ...state.departments
                  .map((e) => e.deptName ?? "")
                  .where((name) => name.isNotEmpty),
            ];

            // Reset deptFilter nếu không còn trong list mới
            final currentDept = deptOptions.contains(_deptFilter)
                ? _deptFilter
                : "Tất cả đơn vị";

            return Column(
              children: [
                _FilterBar(
                  searchController: _searchController,
                  searchKeyword: _searchKeyword,
                  statusFilter: _statusFilter,
                  deptFilter: currentDept,
                  deptOptions: deptOptions,
                  onSearchChanged: (val) =>
                      setState(() => _searchKeyword = val),
                  onSearchCleared: () {
                    _searchController.clear();
                    setState(() => _searchKeyword = "");
                  },
                  onStatusChanged: (val) =>
                      setState(() => _statusFilter = val!),
                  onDeptChanged: (val) => setState(() => _deptFilter = val!),
                ),
                Expanded(
                  child: _UserList(
                    users: state.actors,
                    searchKeyword: _searchKeyword,
                    statusFilter: _statusFilter,
                    deptFilter: currentDept,
                  ),
                ),
              ],
            );
          }
          if (state is ActorListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchKeyword;
  final String statusFilter;
  final String deptFilter;
  final List<String> deptOptions;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onDeptChanged;

  const _FilterBar({
    required this.searchController,
    required this.searchKeyword,
    required this.statusFilter,
    required this.deptFilter,
    required this.deptOptions,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onStatusChanged,
    required this.onDeptChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Tìm kiếm tên hoặc mã người dùng...",
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: AppColors.fieldBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              suffixIcon: searchKeyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: onSearchCleared,
                    )
                  : null,
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Dropdown(
                  value: statusFilter,
                  items: const ["Tất cả", "Hoạt động", "Bị khóa"],
                  onChanged: onStatusChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Dropdown(
                  value: deptFilter,
                  items: deptOptions,
                  onChanged: onDeptChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── User List ─────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  final List<ActorEntity> users;
  final String searchKeyword;
  final String statusFilter;
  final String deptFilter;

  const _UserList({
    required this.users,
    required this.searchKeyword,
    required this.statusFilter,
    required this.deptFilter,
  });

  List<ActorEntity> _filtered() {
    return users.where((user) {
      final matchesSearch = (user.fullName ?? "").toLowerCase().contains(
        searchKeyword.toLowerCase(),
      );
      final matchesDept =
          deptFilter == "Tất cả đơn vị" ||
          user.department?.deptName == deptFilter;
      final matchesStatus =
          statusFilter == "Tất cả" || statusFilter == "Hoạt động";
      return matchesSearch && matchesDept && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "Không tìm thấy kết quả phù hợp",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _UserCard(user: filtered[index]),
    );
  }
}

// ── User Card ─────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  final ActorEntity user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    const isActive = true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            (user.fullName?.isNotEmpty == true)
                ? user.fullName![0].toUpperCase()
                : "?",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName ?? "N/A",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.department?.deptName ?? "Chưa rõ phòng ban",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            const _StatusChip(isActive: isActive),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () => context.push('/user-detail/${user.id}'), // ← go_router
      ),
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────

class _Dropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Status Chip ───────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isActive ? "Đang hoạt động" : "Ngừng hoạt động",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
