// ui/in_out/borrow/borrow_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/borrow_entity.dart';
import 'package:my_app/domain/usecases/borrow_use_case.dart';

// Events
abstract class BorrowEvent {}

class LoadBorrowList extends BorrowEvent {
  final int userId;
  final String? search;
  LoadBorrowList({required this.userId, this.search});
}

class ConfirmReceive extends BorrowEvent {
  final int submissionId;
  final int userId;
  ConfirmReceive({required this.submissionId, required this.userId});
}

class ReturnAssets extends BorrowEvent {
  final int submissionId;
  final int userId;
  final List<int> assetRequestIds;
  ReturnAssets({
    required this.submissionId,
    required this.userId,
    required this.assetRequestIds,
  });
}

// States
abstract class BorrowState {}

class BorrowInitial extends BorrowState {}

class BorrowLoading extends BorrowState {}

class BorrowLoaded extends BorrowState {
  final List<BorrowEntity> items;
  BorrowLoaded(this.items);
}

class BorrowActionSuccess extends BorrowState {
  final String message;
  BorrowActionSuccess(this.message);
}

class BorrowError extends BorrowState {
  final String message;
  BorrowError(this.message);
}

// Bloc
class BorrowBloc extends Bloc<BorrowEvent, BorrowState> {
  final BorrowUseCase useCase;
  int? _currentUserId;

  BorrowBloc({required this.useCase}) : super(BorrowInitial()) {
    on<LoadBorrowList>(_onLoad);
    on<ConfirmReceive>(_onConfirmReceive);
    on<ReturnAssets>(_onReturnAssets);
  }

  Future<void> _onLoad(LoadBorrowList event, Emitter<BorrowState> emit) async {
    _currentUserId = event.userId;
    emit(BorrowLoading());
    try {
      final items = await useCase.getBorrowList(
        event.userId,
        search: event.search,
      );
      emit(BorrowLoaded(items));
    } catch (e) {
      emit(BorrowError(e.toString()));
    }
  }

  Future<void> _onConfirmReceive(
    ConfirmReceive event,
    Emitter<BorrowState> emit,
  ) async {
    emit(BorrowLoading());
    try {
      final response = await useCase.confirmReceive(
        event.submissionId,
        event.userId,
      );
      if (response.success) {
        emit(BorrowActionSuccess(response.message));
        // Reload
        if (_currentUserId != null) {
          final items = await useCase.getBorrowList(_currentUserId!);
          emit(BorrowLoaded(items));
        }
      } else {
        emit(BorrowError(response.message));
      }
    } catch (e) {
      emit(BorrowError(e.toString()));
    }
  }

  Future<void> _onReturnAssets(
    ReturnAssets event,
    Emitter<BorrowState> emit,
  ) async {
    emit(BorrowLoading());
    try {
      final response = await useCase.returnAssets(
        event.submissionId,
        event.userId,
        event.assetRequestIds,
      );
      if (response.success) {
        emit(BorrowActionSuccess(response.message));
        if (_currentUserId != null) {
          final items = await useCase.getBorrowList(_currentUserId!);
          emit(BorrowLoaded(items));
        }
      } else {
        emit(BorrowError(response.message));
      }
    } catch (e) {
      emit(BorrowError(e.toString()));
    }
  }
}
