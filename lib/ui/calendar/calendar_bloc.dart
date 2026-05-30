import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/calendar_entity.dart';
import 'package:my_app/domain/usecases/calendar_usecase.dart';
import 'package:my_app/ui/calendar/calendar_event.dart';
import 'package:my_app/ui/calendar/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarUseCase calendarUseCase;

  CalendarBloc({required this.calendarUseCase}) : super(CalendarInitial()) {
    on<GetCalendarSubmissions>((event, emit) async {
      emit(CalendarLoading());

      try {
        final List<CalendarEntity> result = await calendarUseCase(
          event.month,
          event.year,
        );

        emit(CalendarLoaded(calendar: result));
      } catch (e) {
        String errorMessage = e.toString().replaceAll('Exception: ', '');
        emit(CalendarError(errorMessage));
      }
    });

    on<RefreshCalendar>((event, emit) async {
      try {
        final result = await calendarUseCase(event.month, event.year);
        emit(CalendarLoaded(calendar: result));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    });
  }
}
