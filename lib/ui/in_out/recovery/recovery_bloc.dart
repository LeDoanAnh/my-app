import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/recovery_use_case.dart';
import 'package:my_app/ui/in_out/recovery/recovery_event.dart';
import 'package:my_app/ui/in_out/recovery/recovery_state.dart';

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final RecoveryUseCase useCase;
  int? _currentHandlerId;

  RecoveryBloc({required this.useCase}) : super(RecoveryInitial()) {
    on<LoadRecoveryList>(_onLoad);
    on<ConfirmRecovery>(_onConfirmRecovery);
    on<RemindReturn>(_onRemindReturn);
  }

  Future<void> _onLoad(
    LoadRecoveryList event,
    Emitter<RecoveryState> emit,
  ) async {
    _currentHandlerId = event.handlerId;
    emit(RecoveryLoading());
    try {
      final items = await useCase.getRecoveryList(
        event.handlerId,
        search: event.search,
      );
      emit(RecoveryLoaded(items));
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  Future<void> _onConfirmRecovery(
    ConfirmRecovery event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(RecoveryLoading());
    try {
      final res = await useCase.confirmRecovery(
        event.submissionId,
        event.handlerId,
      );
      if (res.success) {
        emit(RecoveryActionSuccess(res.message));
        if (_currentHandlerId != null) {
          final items = await useCase.getRecoveryList(_currentHandlerId!);
          emit(RecoveryLoaded(items));
        }
      } else {
        emit(RecoveryError(res.message));
      }
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  Future<void> _onRemindReturn(
    RemindReturn event,
    Emitter<RecoveryState> emit,
  ) async {
    // Không emit Loading để không làm reload cả list
    try {
      final res = await useCase.remindReturn(
        event.submissionId,
        event.handlerId,
      );
      if (res.success) {
        emit(RecoveryActionSuccess(res.message));
        // Reload lại list sau khi remind
        if (_currentHandlerId != null) {
          final items = await useCase.getRecoveryList(_currentHandlerId!);
          emit(RecoveryLoaded(items));
        }
      } else {
        emit(RecoveryError(res.message));
      }
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }
}
