// ui/in_out/asset_submission/asset_task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';
import 'package:my_app/domain/usecases/asset_task_use_case.dart';

// Event
abstract class AssetTaskEvent {}

class LoadAssetTasks extends AssetTaskEvent {
  final int deptId;
  final String? search;
  final String? status;
  LoadAssetTasks({required this.deptId, this.search, this.status});
}

class LoadAssetTaskDetail extends AssetTaskEvent {
  final int submissionId;
  final int deptId;
  LoadAssetTaskDetail({required this.submissionId, required this.deptId});
}

class HandoverAssets extends AssetTaskEvent {
  final int submissionId;
  final int handlerId;
  final List<int> assetRequestIds;
  HandoverAssets({
    required this.submissionId,
    required this.handlerId,
    required this.assetRequestIds,
  });
}

// State
abstract class AssetTaskState {}

class AssetTaskInitial extends AssetTaskState {}

class AssetTaskLoading extends AssetTaskState {}

class AssetTaskLoaded extends AssetTaskState {
  final List<AssetTaskEntity> tasks;
  AssetTaskLoaded(this.tasks);
}

class AssetTaskError extends AssetTaskState {
  final String message;
  AssetTaskError(this.message);
}

class AssetTaskDetailLoaded extends AssetTaskState {
  final AssetTaskDetailEntity detail;
  AssetTaskDetailLoaded(this.detail);
}

class AssetTaskHandoverSuccess extends AssetTaskState {
  final String message;
  final bool allHandedOver;
  AssetTaskHandoverSuccess({
    required this.message,
    required this.allHandedOver,
  });
}

// Bloc
class AssetTaskBloc extends Bloc<AssetTaskEvent, AssetTaskState> {
  final AssetTaskUseCase useCase;

  AssetTaskBloc({required this.useCase}) : super(AssetTaskInitial()) {
    on<LoadAssetTasks>(_onLoad);
    on<LoadAssetTaskDetail>(_onLoadDetail);
    on<HandoverAssets>(_onHandover);
  }

  Future<void> _onLoad(
    LoadAssetTasks event,
    Emitter<AssetTaskState> emit,
  ) async {
    emit(AssetTaskLoading());
    try {
      final tasks = await useCase.getAssetTasks(
        deptId: event.deptId,
        search: event.search,
        status: event.status,
      );
      emit(AssetTaskLoaded(tasks));
    } catch (e) {
      emit(AssetTaskError(e.toString()));
    }
  }

  Future<void> _onLoadDetail(
    LoadAssetTaskDetail event,
    Emitter<AssetTaskState> emit,
  ) async {
    emit(AssetTaskLoading());
    try {
      final detail = await useCase.getAssetTaskDetail(
        event.submissionId,
        event.deptId,
      );
      emit(AssetTaskDetailLoaded(detail));
    } catch (e) {
      emit(AssetTaskError(e.toString()));
    }
  }

  Future<void> _onHandover(
    HandoverAssets event,
    Emitter<AssetTaskState> emit,
  ) async {
    emit(AssetTaskLoading());
    try {
      final response = await useCase.handoverAssets(
        event.submissionId,
        event.handlerId,
        event.assetRequestIds,
      );
      if (response.success) {
        emit(
          AssetTaskHandoverSuccess(
            message: response.message,
            allHandedOver: response.allHandedOver ?? false,
          ),
        );
      } else {
        emit(AssetTaskError(response.message));
      }
    } catch (e) {
      emit(AssetTaskError(e.toString()));
    }
  }
}
