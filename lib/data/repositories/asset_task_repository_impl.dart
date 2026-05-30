// data/repositories/asset_task_repository_impl.dart
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/asset_task_model.dart';
import 'package:my_app/domain/entities/asset_task_entity.dart';
import 'package:my_app/domain/repositories/asset_task_repository.dart';

class AssetTaskRepositoryImpl extends AssetTaskRepository {
  final AuthApi api;
  AssetTaskRepositoryImpl(this.api);

  @override
  Future<List<AssetTaskEntity>> getAssetTasks({
    required int deptId,
    String? search,
    String? status,
  }) async {
    try {
      final response = await api.getAssetTasks(deptId, search: search, status: status);
      return response.data?.map(_toEntity).toList() ?? [];
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  AssetTaskEntity _toEntity(AssetTaskModel m) => AssetTaskEntity(
    id: m.id,
    title: m.title,
    status: m.status,
    date: m.date,
    sender: m.sender,
    itemCount: m.itemCount,
    approvedBy: m.approvedBy == null ? null : ApprovedByEntity(
      id: m.approvedBy!.id,
      name: m.approvedBy!.name,
      dept: m.approvedBy!.dept,
      action: m.approvedBy!.action,
      comment: m.approvedBy!.comment,
      approvedAt: m.approvedBy!.approvedAt,
    ),
    assets: m.assets?.map((a) => AssetTaskItemEntity(
      assetId: a.assetId,
      assetName: a.assetName,
      assetCode: a.assetCode,
      unit: a.unit,
      type: a.type,
      status: a.status,
      borrowDate: a.borrowDate,
      expectedReturn: a.expectedReturn,
      borrower: a.borrower == null ? null : AssetTaskBorrowerEntity(
        id: a.borrower!.id,
        name: a.borrower!.name,
        dept: a.borrower!.dept,
      ),
    )).toList(),
  );
  // data/repositories/asset_task_repository_impl.dart — thêm 2 method

  @override
  Future<AssetTaskDetailEntity> getAssetTaskDetail(int submissionId, int deptId) async {
    try {
      final response = await api.getAssetTaskDetail(submissionId, deptId);
      final d = response.data!;
      return AssetTaskDetailEntity(
        id: d.id,
        title: d.title,
        status: d.status,
        date: d.date,
        sender: d.sender,
        approvedBy: d.approvedBy == null ? null : ApprovedByEntity(
          id: d.approvedBy!.id,
          name: d.approvedBy!.name,
          dept: d.approvedBy!.dept,
          comment: d.approvedBy!.comment,
          approvedAt: d.approvedBy!.approvedAt,
        ),
        assets: d.assets?.map((a) => AssetTaskItemEntity(
          assetId: a.assetId,
          assetName: a.assetName,
          assetCode: a.assetCode,
          unit: a.unit,
          type: a.type,
          status: a.status,
          borrowDate: a.borrowDate,
          expectedReturn: a.expectedReturn,
          borrower: a.borrower == null ? null : AssetTaskBorrowerEntity(
            id: a.borrower!.id,
            name: a.borrower!.name,
            dept: a.borrower!.dept,
          ),
        )).toList(),
      );
    } catch (e) {
      throw Exception("Lấy chi tiết đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<HandoverResponse> handoverAssets(int submissionId, int handlerId, List<int> assetRequestIds) async {
    return await api.handoverAssets(submissionId, {
      'handler_id': handlerId,
      'asset_request_ids': assetRequestIds,
    });
  }
}