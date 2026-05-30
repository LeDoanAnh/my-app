abstract class CalendarEvent {}

class GetCalendarSubmissions extends CalendarEvent {
  final int month;
  final int year;

  GetCalendarSubmissions({required this.month, required this.year});
}

class RefreshCalendar extends CalendarEvent {
  final int month;
  final int year;

  RefreshCalendar({required this.month, required this.year});
}
