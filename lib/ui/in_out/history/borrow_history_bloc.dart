import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/history_entity.dart';
import 'package:my_app/domain/usecases/history_use_case.dart';

// ── Events ───────────────────────────────────────────────────

abstract class BorrowHistoryEvent {}

class LoadBorrowHistory extends BorrowHistoryEvent {
  final int userId;
  final String? search;
  LoadBorrowHistory({required this.userId, this.search});
}

// ── States ───────────────────────────────────────────────────

abstract class BorrowHistoryState {}

class BorrowHistoryInitial extends BorrowHistoryState {}

class BorrowHistoryLoading extends BorrowHistoryState {}

class BorrowHistoryLoaded extends BorrowHistoryState {
  final List<BorrowHistoryEntity> items;
  BorrowHistoryLoaded(this.items);
}

class BorrowHistoryError extends BorrowHistoryState {
  final String message;
  BorrowHistoryError(this.message);
}

// ── Bloc ─────────────────────────────────────────────────────

class BorrowHistoryBloc extends Bloc<BorrowHistoryEvent, BorrowHistoryState> {
  final HistoryUseCase useCase;

  BorrowHistoryBloc({required this.useCase}) : super(BorrowHistoryInitial()) {
    on<LoadBorrowHistory>(_onLoad);
  }

  Future<void> _onLoad(
    LoadBorrowHistory event,
    Emitter<BorrowHistoryState> emit,
  ) async {
    emit(BorrowHistoryLoading());
    try {
      final items = await useCase.getBorrowHistory(
        event.userId,
        search: event.search,
      );
      emit(BorrowHistoryLoaded(items));
    } catch (e) {
      emit(BorrowHistoryError(e.toString()));
    }
  }
}
