// data/repositories/borrow_repository_impl.dart
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/borrow_model.dart';
import 'package:my_app/domain/entities/borrow_entity.dart';
import 'package:my_app/domain/repositories/borrow_repository.dart';

class BorrowRepositoryImpl extends BorrowRepository {
  final AuthApi api;
  BorrowRepositoryImpl(this.api);

  @override
  Future<List<BorrowEntity>> getBorrowList(int userId, {String? search}) async {
    try {
      final response = await api.getBorrowList(userId, search: search);
      return response.data?.map(_toEntity).toList() ?? [];
    } catch (e) {
      throw Exception("Lấy danh sách thất bại: ${e.toString()}");
    }
  }

  @override
  Future<BorrowActionResponse> confirmReceive(
    int submissionId,
    int userId,
  ) async {
    return await api.confirmReceive(submissionId, {'user_id': userId});
  }

  @override
  Future<BorrowActionResponse> returnAssets(
    int submissionId,
    int userId,
    List<int> assetRequestIds,
  ) async {
    return await api.returnAssets(submissionId, {
      'user_id': userId,
      'asset_request_ids': assetRequestIds,
    });
  }

  BorrowEntity _toEntity(BorrowModel m) => BorrowEntity(
    submissionId: m.submissionId,
    submissionCode: m.submissionCode,
    title: m.title,
    isReturned: m.isReturned ?? false,
    userConfirmed: m.userConfirmed ?? true,
    isUrgent: m.isUrgent ?? false,
    staffName: m.staffName,
    items:
        m.items
            ?.map(
              (i) => BorrowItemEntity(
                assetRequestId: i.assetRequestId,
                name: i.name,
                qty: i.qty,
                isConsumable: i.isConsumable ?? false,
                status: i.status,
                expectedReturn: i.expectedReturn,
              ),
            )
            .toList() ??
        [],
  );
}
