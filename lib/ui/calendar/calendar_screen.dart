import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/ui/calendar/calendar_bloc.dart';
import 'package:my_app/ui/calendar/calendar_event.dart';
import 'package:my_app/ui/calendar/calendar_state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_app/core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _loadingMonth;
  int? _loadingYear;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents(_focusedDay.month, _focusedDay.year);
  }

  void _fetchEvents(int month, int year) {
    _loadingMonth = month;
    _loadingYear = year;
    context.read<CalendarBloc>().add(
      GetCalendarSubmissions(month: month, year: year),
    );
  }

  void _updateEvents(List<dynamic> entities, int month, int year) {
    final Map<DateTime, List<Map<String, dynamic>>> newEvents = {};

    for (var entity in entities) {
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
        "color": entity.color == 'success'
            ? AppColors.success
            : AppColors.warning,
      });
    }

    setState(() {
      _events.removeWhere(
        (date, _) => date.month == month && date.year == year,
      );
      _events.addAll(newEvents);
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final dateOnly = DateTime.utc(day.year, day.month, day.day);
    return _events[dateOnly] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'Lịch mượn & Phê duyệt',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF7F77DD)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarLoaded) {
            _updateEvents(
              state.calendar,
              _loadingMonth ?? _focusedDay.month,
              _loadingYear ?? _focusedDay.year,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // ── Calendar card ──────────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE8E8E8),
                    width: 0.5,
                  ),
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
                            e['status'] == 'Đang phê duyệt' ||
                            e['status'] == 'PENDING',
                      );
                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDot(
                              hasPending
                                  ? const Color(0xFFEF9F27)
                                  : const Color(0xFF7F77DD),
                            ),
                            if (events.length > 1) ...[
                              const SizedBox(width: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF7F77DD,
                                  ).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '+${events.length - 1}',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7F77DD),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    // Today
                    todayDecoration: const BoxDecoration(
                      color: Color(0xFFEEEDFE),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                      color: Color(0xFF7F77DD),
                      fontWeight: FontWeight.w600,
                    ),
                    // Selected
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF7F77DD),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    // Dots
                    markerSize: 0,
                    outsideDaysVisible: false,
                    defaultTextStyle: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 13,
                    ),
                    weekendTextStyle: const TextStyle(
                      color: Color(0xFFD85A30),
                      fontSize: 13,
                    ),
                    // Row height để dot không bị cắt
                    rowDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    cellMargin: const EdgeInsets.all(4),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                    leftChevronIcon: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEDFE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF7F77DD),
                        size: 18,
                      ),
                    ),
                    rightChevronIcon: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEDFE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF7F77DD),
                        size: 18,
                      ),
                    ),
                    headerPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFAAAAAA),
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFD85A30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // ── Section header ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_note_rounded,
                      size: 18,
                      color: Color(0xFF7F77DD),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sự kiện ngày ${_selectedDay?.day ?? _focusedDay.day}/${_selectedDay?.month ?? _focusedDay.month}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (state is CalendarLoading)
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF7F77DD),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Event list — scroll độc lập ─────────────────────────
              Expanded(
                child: state is CalendarError
                    ? Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      )
                    : _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
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

  // ── Helper widgets ───────────────────────────────────────────────────

  Widget _buildDot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> item) {
    final String status = item['status'] ?? 'N/A';
    final String type = item['type'] ?? 'Vật dụng';
    final String title = item['title'] ?? 'Không có tiêu đề';
    final String time = item['time'] ?? '--:--';
    final bool isPending = status == 'Đang phê duyệt' || status == 'PENDING';

    // Màu riêng cho từng loại trạng thái
    final Color cardAccent = isPending
        ? const Color(0xFFEF9F27)
        : const Color(0xFF7F77DD);
    final Color cardAccentBg = isPending
        ? const Color(0xFFFAEEDA)
        : const Color(0xFFEEEDFE);
    final Color badgeBg = isPending
        ? const Color(0xFFFAEEDA)
        : const Color(0xFFEAF3DE);
    final Color badgeText = isPending
        ? const Color(0xFF854F0B)
        : const Color(0xFF3B6D11);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cardAccentBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                type == 'Địa điểm'
                    ? Icons.room_rounded
                    : Icons.inventory_2_rounded,
                color: cardAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: Color(0xFFAAAAAA),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: badgeText,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Trailing icon
            Icon(
              isPending
                  ? Icons.hourglass_empty_rounded
                  : Icons.check_circle_outline_rounded,
              color: cardAccent,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 56,
            color: const Color(0xFFAAAAAA).withOpacity(0.5),
          ),
          const SizedBox(height: 14),
          const Text(
            'Không có lịch trình nào',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFFAAAAAA),
            ),
          ),
        ],
      ),
    );
  }
}
