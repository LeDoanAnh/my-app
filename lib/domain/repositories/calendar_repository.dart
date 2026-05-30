import 'package:my_app/domain/entities/calendar_entity.dart';

abstract class CalendarRepository {
  Future<List<CalendarEntity>> getCalendarSubmissions(int month, int year);
}
