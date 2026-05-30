import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_screen.dart';
import 'package:my_app/ui/location_asset/create_resource_screen.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_screen.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_bloc.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_event.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_state.dart';
import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';
import 'package:my_app/l10n/ui_text.dart';

class AssetLocationListScreen extends StatefulWidget {
  const AssetLocationListScreen({super.key});

  @override
  State<AssetLocationListScreen> createState() =>
      _AssetLocationListScreenState();
}

class _AssetLocationListScreenState extends State<AssetLocationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      context.read<AssetLocationListBloc>().add(
        SearchResourceEvent(_searchController.text),
      );
    });
    _tabController.addListener(() {
      setState(() {});
    });
    context.read<AssetLocationListBloc>().add(GetAssetLocationList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetLocationListBloc, AssetLocationListState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.fieldBg,
          appBar: AppBar(
            title: const TrText(
              "Quản lý Vật chất",
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/create-resource');
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "VẬT TƯ"),
                Tab(text: "ĐỊA ĐIỂM"),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              Expanded(child: _buildBody(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(AssetLocationListState state) {
    if (state is AssetLocationListLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is AssetLocationListLoaded) {
      return TabBarView(
        controller: _tabController,
        children: [
          _buildAssetList(state.assets),
          _buildLocationList(state.locations),
        ],
      );
    } else if (state is AssetLocationListError) {
      return Center(child: TrText(state.message));
    }
    return const SizedBox();
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _tabController.index == 0
              ? "Tìm mã hoặc tên vật tư..."
              : "Tìm tên địa điểm...",
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppColors.fieldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAssetList(List<AssetEntity> assets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final item = assets[index];
        // Logic phân loại dựa trên mã hoặc quy ước của bạn (ở đây tạm giữ logic type fixed/consumable)
        bool isFixed = item.assetCode?.contains("AS") ?? true;

        return _buildItemCard(
          title: item.assetName ?? "N/A",
          subtitle: "Mã: ${item.assetCode} | ĐVT: ${item.unit}",
          tag: isFixed ? "MƯỢN TRẢ" : "TIÊU HAO",
          tagColor: isFixed ? Colors.blue : Colors.orange,
          status: item.status ?? "unknown",
          icon: isFixed
              ? Icons.inventory_2_outlined
              : Icons.water_drop_outlined,
          onTap: () => context.push('/asset-detail/${item.id}'),
        );
      },
    );
  }

  Widget _buildLocationList(List<LocationEntity> locations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final loc = locations[index];
        return _buildItemCard(
          title: loc.locationName ?? "N/A",
          subtitle:
              "Sức chứa: ${loc.capacity} | ${loc.department?.deptName ?? ''}",
          tag: "ĐỊA ĐIỂM",
          tagColor: Colors.purple,
          status: loc.status ?? "unknown",
          icon: Icons.location_on_outlined,
          onTap: () => context.push('/location-detail/${loc.id}'),
        );
      },
    );
  }

  Widget _buildItemCard({
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required String status,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tagColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TrText(
                          tag,
                          style: TextStyle(
                            color: tagColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TrText(
                          status.toLowerCase(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TrText(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    TrText(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
