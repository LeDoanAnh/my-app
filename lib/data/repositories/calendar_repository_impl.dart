import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/calendar_model.dart';
import 'package:my_app/domain/entities/calendar_entity.dart';
import 'package:my_app/domain/repositories/calendar_repository.dart';


class CalendarRepositoryImpl extends CalendarRepository {
  final AuthApi api;

  CalendarRepositoryImpl(this.api);

  @override
  Future<List<CalendarEntity>> getCalendarSubmissions(int month, int year) async {
    try {
      final CalendarResponseModel response = await api.getCalendarSubmissions(month, year);

      final List<CalendarEntity> allEntities = [];

      if (response.data != null) {
        response.data!.forEach((dateKey, listModels) {
          final DateTime eventDate = DateTime.parse(dateKey);
          for (var model in listModels) {
            allEntities.add(model.toEntity(eventDate));
          }
        });
      }
      return allEntities;

    } catch (e) {
      throw Exception("Lấy danh sách lịch thất bại: ${e.toString()}");
    }
  }
}