import 'package:my_app/domain/entities/calendar_entity.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<CalendarEntity> calendar;

  CalendarLoaded({required this.calendar});
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);
}
