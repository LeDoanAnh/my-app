import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/history_entity.dart';
import 'package:my_app/ui/in_out/history/borrow_history_bloc.dart';
import 'package:my_app/ui/in_out/history/handover_history_bloc.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;
  final List<int?> userRoles;
  const HistoryScreen({
    super.key,
    required this.userId,
    required this.userRoles,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  bool get _canSeeHandover => widget.userRoles.contains(3);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _canSeeHandover ? 2 : 1,
      vsync: this,
    );

    // Load tab 1 ngay
    context.read<BorrowHistoryBloc>().add(
      LoadBorrowHistory(userId: widget.userId),
    );

    // Load tab 2 nếu có quyền
    if (_canSeeHandover) {
      context.read<HandoverHistoryBloc>().add(
        LoadHandoverHistory(userId: widget.userId),
      );
    }

    // Khi chuyển tab → clear search + reload
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _searchController.clear();
        if (_tabController.index == 0) {
          context.read<BorrowHistoryBloc>().add(
            LoadBorrowHistory(userId: widget.userId),
          );
        } else if (_tabController.index == 1 && _canSeeHandover) {
          context.read<HandoverHistoryBloc>().add(
            LoadHandoverHistory(userId: widget.userId),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final search = query.isEmpty ? null : query;
    if (_tabController.index == 0) {
      context.read<BorrowHistoryBloc>().add(
        LoadBorrowHistory(userId: widget.userId, search: search),
      );
    } else {
      context.read<HandoverHistoryBloc>().add(
        LoadHandoverHistory(userId: widget.userId, search: search),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldAlt,
      appBar: AppBar(
        title: const Text(
          "LỊCH SỬ",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showDateFilter,
            icon: const Icon(Icons.filter_list, color: AppColors.textDark),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.fieldBgAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  const Tab(text: "Lịch sử mượn trả"),
                  if (_canSeeHandover) const Tab(text: "Lịch sử bàn giao"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Tab 1: Lịch sử mượn trả ──────────────────────────
          BlocBuilder<BorrowHistoryBloc, BorrowHistoryState>(
            builder: (context, state) {
              if (state is BorrowHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BorrowHistoryLoaded) {
                if (state.items.isEmpty) {
                  return _buildEmptyState("Chưa có lịch sử mượn trả");
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (_, i) =>
                      _buildBorrowHistoryCard(state.items[i]),
                );
              } else if (state is BorrowHistoryError) {
                return _buildErrorState(state.message, () {
                  context.read<BorrowHistoryBloc>().add(
                    LoadBorrowHistory(userId: widget.userId),
                  );
                });
              }
              return const SizedBox();
            },
          ),

          // ── Tab 2: Lịch sử bàn giao (role = 3 only) ──────────
          if (_canSeeHandover)
            BlocBuilder<HandoverHistoryBloc, HandoverHistoryState>(
              builder: (context, state) {
                if (state is HandoverHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HandoverHistoryLoaded) {
                  if (state.items.isEmpty) {
                    return _buildEmptyState("Chưa có lịch sử bàn giao");
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (_, i) =>
                        _buildHandoverHistoryCard(state.items[i]),
                  );
                } else if (state is HandoverHistoryError) {
                  return _buildErrorState(state.message, () {
                    context.read<HandoverHistoryBloc>().add(
                      LoadHandoverHistory(userId: widget.userId),
                    );
                  });
                }
                return const SizedBox();
              },
            ),
        ],
      ),
    );
  }

  // ── Card: Lịch sử mượn trả ─────────────────────────────────

  Widget _buildBorrowHistoryCard(BorrowHistoryEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withAlpha(25), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.submissionCode ?? "#${item.submissionId}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTag("HOÀN THÀNH", Colors.green),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title ?? "Không có tiêu đề",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.person_outline,
            "Người mượn:",
            item.borrowerName ?? '-',
          ),
          const SizedBox(height: 4),
          _buildInfoRow(
            Icons.assignment_turned_in_outlined,
            "Người thu hồi:",
            item.receiverName ?? '-',
          ),
          const Divider(height: 24),
          _buildItemList(item.items),
          const SizedBox(height: 16),
          _buildStatusBox(
            icon: Icons.check_circle,
            text: "Đã nhập kho: ${item.completedDate ?? '-'}",
            color: Colors.green,
            bgColor: AppColors.successBgSoft,
          ),
        ],
      ),
    );
  }

  // ── Card: Lịch sử bàn giao ──────────────────────────────────

  Widget _buildHandoverHistoryCard(HandoverHistoryEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withAlpha(25), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.code ?? "#${item.id}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTag("BÀN GIAO", Colors.blue),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title ?? "Không có tiêu đề",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Mũi tên từ → đến
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.fieldBgAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.fromDept ?? '-',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.blueGrey,
                  size: 18,
                ),
                Expanded(
                  child: Text(
                    item.toDept ?? '-',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.manage_accounts_outlined,
            "Người bàn giao:",
            item.handoverBy ?? '-',
          ),
          const Divider(height: 24),
          _buildItemList(item.items),
          const SizedBox(height: 16),
          _buildStatusBox(
            icon: Icons.check_circle,
            text: "Ngày bàn giao: ${item.handoverDate ?? '-'}",
            color: Colors.blue,
            bgColor: const Color(0xFFE3F2FD),
          ),
        ],
      ),
    );
  }

  // ── Shared Widgets ──────────────────────────────────────────

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          "$label ",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemList(List<HistoryItemEntity> items) {
    return Column(
      children: items
          .map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.done_all, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      i.name ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  if (i.isConsumable)
                    const Text(
                      "(Tiêu hao) ",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  Text(
                    "x${i.qty ?? 1}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatusBox({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text("Thử lại")),
        ],
      ),
    );
  }

  void _showDateFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lọc theo ngày",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // TODO: tích hợp DateRangePicker
            const Text(
              "(DateRangePicker sẽ tích hợp ở đây)",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
