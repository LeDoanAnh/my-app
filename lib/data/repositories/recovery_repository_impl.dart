import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/recovery_model.dart';
import 'package:my_app/domain/entities/recovery_entity.dart';
import 'package:my_app/domain/repositories/recovery_repository.dart';

class RecoveryRepositoryImpl extends RecoveryRepository {
  final AuthApi api;
  RecoveryRepositoryImpl(this.api);

  @override
  Future<List<RecoveryEntity>> getRecoveryList(int handlerId, {String? search}) async {
    try {
      final response = await api.getRecoveryList(handlerId, search: search);
      return response.data?.map(_toEntity).toList() ?? [];
    } catch (e) {
      throw Exception("Lấy danh sách thu hồi thất bại: ${e.toString()}");
    }
  }

  @override
  Future<RecoveryActionResponse> confirmRecovery(int submissionId, int handlerId) async {
    try {
      final res = await api.confirmRecovery(submissionId, {'handler_id': handlerId});
      return RecoveryActionResponse(success: res.success, message: res.message);
    } catch (e) {
      throw Exception("Xác nhận thu hồi thất bại: ${e.toString()}");
    }
  }

  @override
  Future<RecoveryActionResponse> remindReturn(int submissionId, int handlerId) async {
    try {
      final res = await api.remindReturn(submissionId, {'handler_id': handlerId});
      return RecoveryActionResponse(success: res.success, message: res.message);
    } catch (e) {
      throw Exception("Gửi nhắc nhở thất bại: ${e.toString()}");
    }
  }

  RecoveryEntity _toEntity(RecoveryModel m) => RecoveryEntity(
    submissionId: m.submissionId,
    submissionCode: m.submissionCode,
    title: m.title,
    borrowerName: m.borrowerName,
    borrowerId: m.borrowerId,
    isReturned: m.isReturned ?? false,
    userConfirmed: m.userConfirmed ?? true,
    isUrgent: m.isUrgent ?? false,
    returnDate: m.returnDate,
    items: m.items
        ?.map((i) => RecoveryItemEntity(
      assetRequestId: i.assetRequestId,
      name: i.name,
      qty: i.qty,
      status: i.status,
      expectedReturn: i.expectedReturn,
    ))
        .toList() ??
        [],
  );
}