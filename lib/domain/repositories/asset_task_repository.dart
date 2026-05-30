// domain/repositories/asset_task_repository.dart
import 'package:my_app/data/model/asset_task_model.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';

abstract class AssetTaskRepository {
  Future<List<AssetTaskEntity>> getAssetTasks({
    required int deptId,
    String? search,
    String? status,
  });
  Future<AssetTaskDetailEntity> getAssetTaskDetail(
    int submissionId,
    int deptId,
  );
  Future<HandoverResponse> handoverAssets(
    int submissionId,
    int handlerId,
    List<int> assetRequestIds,
  );
}
