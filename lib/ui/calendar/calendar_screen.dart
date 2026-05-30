import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/ui/calendar/calendar_bloc.dart';
import 'package:my_app/ui/calendar/calendar_event.dart';
import 'package:my_app/ui/calendar/calendar_state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/l10n/ui_text.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map chứa dữ liệu đã được format để hiển thị lên TableCalendar
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Gọi API lấy dữ liệu tháng hiện tại ngay khi vào màn hình
    _fetchEvents(_focusedDay.month, _focusedDay.year);
  }

  void _fetchEvents(int month, int year) {
    context.read<CalendarBloc>().add(
      GetCalendarSubmissions(month: month, year: year),
    );
  }

  // Hàm quan trọng nhất: Chuyển từ List<Entity> sang Map cho giao diện
  void _updateEvents(List<dynamic> entities) {
    final Map<DateTime, List<Map<String, dynamic>>> newEvents = {};

    for (var entity in entities) {
      // Chuyển DateTime về dạng UTC date only để TableCalendar so sánh được
      final date = DateTime.utc(
        entity.date.year,
        entity.date.month,
        entity.date.day,
      );

      if (newEvents[date] == null) newEvents[date] = [];

      newEvents[date]!.add({
        "title": entity.title,
        "type": entity.type,
        "status": entity.status,
        "time": entity.time,
        // Ánh xạ màu từ String sang AppColors
        "color": entity.color == 'success'
            ? AppColors.success
            : AppColors.warning,
      });
    }

    setState(() {
      _events = newEvents;
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    DateTime dateOnly = DateTime.utc(day.year, day.month, day.day);
    return _events[dateOnly] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const TrText(
          "Lịch mượn & Phê duyệt",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      // Dùng BlocConsumer để lắng nghe state và cập nhật dữ liệu
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarLoaded) {
            _updateEvents(state.calendar);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // 1. Phần Lịch (TableCalendar)
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textDark.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Tháng',
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) =>
                      setState(() => _calendarFormat = format),
                  // Gọi API khi người dùng chuyển tháng
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    _fetchEvents(focusedDay.month, focusedDay.year);
                  },
                  eventLoader: _getEventsForDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return null;
                      final dayEvents = events.cast<Map<String, dynamic>>();
                      final bool hasPending = dayEvents.any(
                        (e) =>
                            e['status'] == "Đang phê duyệt" ||
                            e['status'] == "PENDING",
                      );
                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSmallDot(
                              hasPending
                                  ? AppColors.warning
                                  : AppColors.primary,
                            ),
                            if (events.length > 1)
                              Container(
                                margin: const EdgeInsets.only(left: 2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TrText(
                                  "+${events.length - 1}",
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 0,
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(color: AppColors.textDark),
                    weekendTextStyle: TextStyle(color: AppColors.error),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.textDark,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.primary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              // 2. Tiêu đề danh sách
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_note_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    TrText(
                      "Sự kiện ngày ${_selectedDay?.day ?? _focusedDay.day}/${_selectedDay?.month ?? _focusedDay.month}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (state is CalendarLoading)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
              ),

              // 3. Danh sách (ListView)
              Expanded(
                child: state is CalendarError
                    ? Center(
                        child: TrText(
                          state.message,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      )
                    : _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _getEventsForDay(
                          _selectedDay ?? _focusedDay,
                        ).length,
                        itemBuilder: (context, index) {
                          final item = _getEventsForDay(
                            _selectedDay ?? _focusedDay,
                          )[index];
                          return _buildEventCard(item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Các hàm build Widget phụ giữ nguyên 100% logic UI cũ ---
  Widget _buildSmallDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> item) {
    final String status = item['status'] ?? "N/A";
    final Color color = item['color'] ?? AppColors.textGrey;
    final String type = item['type'] ?? "Vật dụng";
    final String title = item['title'] ?? "Không có tiêu đề";
    final String time = item['time'] ?? "--:--";
    bool isPending = status == "Đang phê duyệt" || status == "PENDING";

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
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            type == "Địa điểm" ? Icons.room_rounded : Icons.inventory_2_rounded,
            color: color,
          ),
        ),
        title: TrText(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            TrText(
              time,
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TrText(
                status.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          isPending
              ? Icons.hourglass_empty_rounded
              : Icons.check_circle_outline_rounded,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Opacity(
        opacity: 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 64,
              color: AppColors.textGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const TrText(
              "Không có lịch trình nào",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
