import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/asset_detail_entity.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_bloc.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_event.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_state.dart';
import 'package:my_app/l10n/ui_text.dart';

class AssetDetailScreen extends StatefulWidget {
  final int assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi sự kiện lấy dữ liệu từ BLoC ngay khi khởi tạo
    context.read<AssetDetailBloc>().add(GetAssetDetail(widget.assetId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const TrText(
          "Chi tiết Vật tư",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<AssetDetailBloc, AssetDetailState>(
        builder: (context, state) {
          if (state is AssetDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssetDetailError) {
            return _buildErrorWidget(state.message);
          }

          if (state is AssetDetailLoaded) {
            final asset = state.asset;
            return _buildContent(asset);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Widget hiển thị nội dung chính khi đã có dữ liệu
  Widget _buildContent(AssetDetailEntity asset) {
    final bool isFixed = !(asset.isConsumable ?? false);
    final bool isBorrowed = asset.status == "Đang cho mượn";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainHeader(asset),
          const SizedBox(height: 25),

          _buildSectionTitle("THÔNG SỐ & QUẢN LÝ"),
          _buildInfoBox([
            _buildRow(
              Icons.qr_code_2_rounded,
              "Mã tài sản",
              asset.assetCode ?? "N/A",
            ),
            _buildRow(
              Icons.business_center_outlined,
              "Đơn vị quản lý",
              asset.deptName ?? "N/A",
            ),
            _buildRow(
              Icons.layers_outlined,
              "Phân loại",
              isFixed ? "Tài sản cố định" : "Vật tư tiêu hao",
            ),
            _buildRow(
              Icons.straighten_rounded,
              "Đơn vị tính",
              asset.unit ?? "N/A",
            ),
          ]),

          const SizedBox(height: 25),

          // Hiển thị thông tin mượn nếu là tài sản cố định và đang bị mượn
          if (isFixed && isBorrowed && asset.currentRequest != null) ...[
            _buildSectionTitle("THÔNG TIN MƯỢN HIỆN TẠI"),
            _buildBorrowingCard(asset.currentRequest!),
            const SizedBox(height: 25),
          ],

          _buildSectionTitle("LỊCH SỬ HOẠT ĐỘNG"),
          if (asset.history != null && asset.history!.isNotEmpty)
            ...asset.history!.map((h) => _buildHistoryItem(h)).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: TrText(
                  "Chưa có lịch sử hoạt động",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainHeader(AssetDetailEntity asset) {
    final bool isAvailable = asset.status == "Sẵn sàng";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: AppColors.primary,
              size: 35,
            ),
          ),
          const SizedBox(height: 16),
          TrText(
            asset.assetName ?? "N/A",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: (isAvailable ? Colors.green : Colors.orange).withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TrText(
              (asset.status ?? "N/A").toUpperCase(),
              style: TextStyle(
                color: isAvailable ? Colors.green : Colors.orange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowingCard(CurrentRequest req) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_search_rounded,
                color: Colors.orange,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TrText(
                  req.borrower ?? "N/A",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildSmallDetail(
            Icons.calendar_today,
            "Ngày mượn",
            req.borrowDate ?? "---",
          ),
          _buildSmallDetail(
            Icons.event_busy,
            "Hạn trả",
            req.expectedReturn ?? "---",
            isAlert: true,
          ),
          _buildSmallDetail(
            Icons.admin_panel_settings_outlined,
            "Người duyệt",
            req.handler ?? "---",
          ),
          _buildSmallDetail(
            Icons.notes_rounded,
            "Ghi chú",
            req.note ?? "Không có ghi chú",
          ),
        ],
      ),
    );
  }

  Widget _buildSmallDetail(
    IconData icon,
    String label,
    String value, {
    bool isAlert = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          TrText(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Expanded(
            child: TrText(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isAlert ? Colors.red : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.7)),
          const SizedBox(width: 12),
          TrText(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TrText(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: TrText(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInfoBox(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildHistoryItem(History history) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.fieldBg,
            child: Icon(Icons.history, size: 18, color: Colors.blueGrey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(
                  history.user ?? "N/A",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                TrText(
                  history.action ?? "N/A",
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TrText(
            history.date ?? "",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          TrText(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AssetDetailBloc>().add(
              GetAssetDetail(widget.assetId),
            ),
            child: const TrText("Thử lại"),
          ),
        ],
      ),
    );
  }
}
