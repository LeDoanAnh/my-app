// domain/usecases/asset_task_use_case.dart
import 'package:my_app/data/model/asset_task_model.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';
import 'package:my_app/domain/repositories/asset_task_repository.dart';

class AssetTaskUseCase {
  final AssetTaskRepository repository;
  AssetTaskUseCase({required this.repository});

  Future<List<AssetTaskEntity>> getAssetTasks({
    required int deptId,
    String? search,
    String? status,
  }) {
    return repository.getAssetTasks(deptId: deptId, search: search, status: status);
  }

  Future<AssetTaskDetailEntity> getAssetTaskDetail(int submissionId, int deptId) {
    return repository.getAssetTaskDetail(submissionId, deptId);
  }

  Future<HandoverResponse> handoverAssets(int submissionId, int handlerId, List<int> assetRequestIds) {
    return repository.handoverAssets(submissionId, handlerId, assetRequestIds);
  }
}