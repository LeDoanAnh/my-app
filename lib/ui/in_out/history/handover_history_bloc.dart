import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/history_entity.dart';
import 'package:my_app/domain/usecases/history_use_case.dart';

// ── Events ───────────────────────────────────────────────────

abstract class HandoverHistoryEvent {}

class LoadHandoverHistory extends HandoverHistoryEvent {
  final int userId;
  final String? search;
  LoadHandoverHistory({this.search, required this.userId});
}

// ── States ───────────────────────────────────────────────────

abstract class HandoverHistoryState {}

class HandoverHistoryInitial extends HandoverHistoryState {}

class HandoverHistoryLoading extends HandoverHistoryState {}

class HandoverHistoryLoaded extends HandoverHistoryState {
  final List<HandoverHistoryEntity> items;
  HandoverHistoryLoaded(this.items);
}

class HandoverHistoryError extends HandoverHistoryState {
  final String message;
  HandoverHistoryError(this.message);
}

// ── Bloc ─────────────────────────────────────────────────────

class HandoverHistoryBloc
    extends Bloc<HandoverHistoryEvent, HandoverHistoryState> {
  final HistoryUseCase useCase;

  HandoverHistoryBloc({required this.useCase})
    : super(HandoverHistoryInitial()) {
    on<LoadHandoverHistory>(_onLoad);
  }

  Future<void> _onLoad(
    LoadHandoverHistory event,
    Emitter<HandoverHistoryState> emit,
  ) async {
    emit(HandoverHistoryLoading());
    try {
      final items = await useCase.getHandoverHistory(
        event.userId,
        search: event.search,
      );
      emit(HandoverHistoryLoaded(items));
    } catch (e) {
      emit(HandoverHistoryError(e.toString()));
    }
  }
}
