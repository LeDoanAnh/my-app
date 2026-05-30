import 'package:my_app/domain/entities/calendar_entity.dart';
import 'package:my_app/domain/repositories/calendar_repository.dart';

class CalendarUseCase {
  final CalendarRepository repository;

  CalendarUseCase({required this.repository});

  Future<List<CalendarEntity>> call(int month, int year) async {
    return await repository.getCalendarSubmissions(month, year);
  }
}
