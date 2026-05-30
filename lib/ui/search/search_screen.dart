import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/search_entity.dart';
import 'package:my_app/ui/search/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  final int userId;

  const SearchScreen({super.key, required this.userId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  List<Map<String, String>> _filters() => [
    {'label': 'Tất cả', 'value': 'all'},
    {'label': 'Tờ trình', 'value': 'submission'},
    {'label': 'Thiết bị', 'value': 'asset'},
    {'label': 'Nhân viên', 'value': 'user'},
    {'label': 'Phòng ban', 'value': 'department'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchHistoryLoaded());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    context.read<SearchBloc>().add(
      SearchQueryChanged(
        userId: widget.userId,
        query: query,
        filter: _selectedFilter,
      ),
    );
  }

  void _onSubmitted(String query) {
    if (query.trim().isEmpty) return;
    context.read<SearchBloc>().add(
      SearchSubmitted(
        userId: widget.userId,
        query: query,
        filter: _selectedFilter,
      ),
    );
  }

  void _applyHistory(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);
    _onSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    final filters = _filters();

    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onChanged,
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tờ trình, thiết bị...',
              hintStyle: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            color: AppColors.background,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = _selectedFilter == filter['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter['label']!),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedFilter = filter['value']!);
                      if (_searchController.text.isNotEmpty) {
                        _onChanged(_searchController.text);
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textGrey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: AppColors.fieldBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return _buildHistory(state.history);
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return _buildResults(state.results);
                } else if (state is SearchError) {
                  return _buildError(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(List<String> history) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: 72,
              color: AppColors.textGrey.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Nhập từ khóa để tìm kiếm',
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tìm kiếm gần đây',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<SearchBloc>().add(SearchHistoryCleared()),
                child: Text(
                  'Xóa tất cả',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (_, i) {
              final query = history[i];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.history,
                  size: 18,
                  color: AppColors.textGrey,
                ),
                title: Text(
                  query,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                  onPressed: () {
                    context.read<SearchBloc>().add(
                      SearchHistoryItemDeleted(query),
                    );
                  },
                ),
                onTap: () => _applyHistory(query),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResults(List<SearchResultEntity> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: AppColors.textGrey.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy kết quả phù hợp',
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (_, i) => _buildResultCard(results[i]),
    );
  }

  Widget _buildResultCard(SearchResultEntity item) {
    final meta = _categoryMeta(item.category ?? 'unknown');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (meta['color'] as Color).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            meta['icon'] as IconData,
            color: meta['color'] as Color,
            size: 20,
          ),
        ),
        title: Text(
          item.title?.toUpperCase() ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          "${meta['label']} - ${item.status}",
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.textGrey,
        ),
        onTap: () {
          context.read<SearchBloc>().add(
            SearchSubmitted(
              userId: widget.userId,
              query: _searchController.text,
              filter: _selectedFilter,
            ),
          );
          final refId = item.refId;
          if (item.category == 'submission') {
            context.push('/submission-detail/$refId');
          } else if (item.category == 'asset') {
            context.push('/asset-detail/$refId');
          } else if (item.category == 'user') {
            context.push('/user-detail/$refId');
          } else if (item.category == 'department') {
            context.push('/department-detail/$refId');
          }
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<SearchBloc>().add(SearchHistoryLoaded()),
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _categoryMeta(String category) {
    switch (category) {
      case 'submission':
        return {
          'icon': Icons.description_outlined,
          'color': Colors.indigo,
          'label': 'Tờ trình',
        };
      case 'asset':
        return {
          'icon': Icons.devices_outlined,
          'color': Colors.teal,
          'label': 'Thiết bị',
        };
      case 'user':
        return {
          'icon': Icons.person_outline,
          'color': Colors.orange,
          'label': 'Nhân viên',
        };
      case 'department':
        return {
          'icon': Icons.business_outlined,
          'color': Colors.purple,
          'label': 'Phòng ban',
        };
      default:
        return {'icon': Icons.search, 'color': Colors.grey, 'label': 'Khác'};
    }
  }
}
