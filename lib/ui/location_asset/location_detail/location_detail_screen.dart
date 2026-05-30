import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/location_detail_entity.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_bloc.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_event.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_state.dart';

class LocationDetailScreen extends StatefulWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi Bloc để lấy dữ liệu ngay khi vào màn hình
    context.read<LocationDetailBloc>().add(
      GetLocationDetail(widget.locationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const Text(
          "Chi tiết Địa điểm",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<LocationDetailBloc, LocationDetailState>(
        builder: (context, state) {
          if (state is LocationDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationDetailLoaded) {
            return _buildMainContent(state.locationDetail);
          } else if (state is LocationDetailError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMainContent(LocationDetailEntity data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusHeader(data),
          const SizedBox(height: 25),
          _buildSectionTitle("THÔNG TIN CƠ BẢN"),
          _buildInfoBox([
            _buildDetailRow(
              Icons.business_rounded,
              "Đơn vị quản lý",
              data.deptName ?? "N/A",
            ),
            _buildDetailRow(
              Icons.groups_outlined,
              "Sức chứa tối đa",
              "${data.capacity ?? 0} người",
            ),
            _buildDetailRow(
              Icons.add_location_outlined,
              "Địa chỉ",
              data.address ?? "Không có mô tả",
            ),
          ]),
          const SizedBox(height: 25),

          // Chỉ hiển thị mục này nếu có người đang sử dụng
          if (data.currentBooking != null) ...[
            _buildSectionTitle("TRẠNG THÁI HIỆN TẠI"),
            _buildCurrentUsageCard(data.currentBooking!),
            const SizedBox(height: 25),
          ],

          if (data.upcomingEvents != null &&
              data.upcomingEvents!.isNotEmpty) ...[
            _buildSectionTitle("LỊCH SỰ KIỆN SẮP TỚI"),
            ...data.upcomingEvents!
                .map((e) => _buildEventItem(e.title ?? "N/A", e.date ?? "N/A"))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusHeader(LocationDetailEntity data) {
    bool isBusy = data.status == "Đang sử dụng";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: (isBusy ? Colors.red : Colors.green).withOpacity(
              0.1,
            ),
            child: Icon(
              Icons.meeting_room_rounded,
              color: isBusy ? Colors.red : Colors.green,
              size: 35,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            data.locationName ?? "N/A",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (isBusy ? Colors.red : Colors.green).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (data.status ?? "Trống").toUpperCase(),
              style: TextStyle(
                color: isBusy ? Colors.red : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUsageCard(BookingEntity booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ĐANG DIỄN RA",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            booking.title ?? "Không có tiêu đề",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                "${booking.time} | ${booking.date}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_pin_circle_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Đơn vị: ${booking.organizer ?? "N/A"}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Các Widget phụ trợ giữ nguyên logic UI nhưng đổi tham số truyền vào
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available,
              color: Colors.blue,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
