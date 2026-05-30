import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/history_model.dart';
import 'package:my_app/domain/entities/history_entity.dart';
import 'package:my_app/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  final AuthApi api;
  HistoryRepositoryImpl(this.api);

  @override
  Future<List<BorrowHistoryEntity>> getBorrowHistory(
    int userId, {
    String? search,
  }) async {
    try {
      final res = await api.getBorrowHistory(userId, search: search);
      return res.data?.map(_toBorrowEntity).toList() ?? [];
    } catch (e) {
      throw Exception("Lấy lịch sử mượn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<List<HandoverHistoryEntity>> getHandoverHistory(
    int userId, {
    String? search,
  }) async {
    try {
      final res = await api.getHandoverHistory(userId, search: search);
      return res.data?.map(_toHandoverEntity).toList() ?? [];
    } catch (e) {
      throw Exception("Lấy lịch sử bàn giao thất bại: ${e.toString()}");
    }
  }

  BorrowHistoryEntity _toBorrowEntity(BorrowHistoryModel m) =>
      BorrowHistoryEntity(
        submissionId: m.submissionId,
        submissionCode: m.submissionCode,
        title: m.title,
        borrowerName: m.borrowerName,
        receiverName: m.receiverName,
        completedDate: m.completedDate,
        items: m.items?.map(_toItemEntity).toList() ?? [],
      );

  HandoverHistoryEntity _toHandoverEntity(HandoverHistoryModel m) =>
      HandoverHistoryEntity(
        id: m.id,
        code: m.code,
        title: m.title,
        fromDept: m.fromDept,
        toDept: m.toDept,
        handoverBy: m.handoverBy,
        handoverDate: m.handoverDate,
        items: m.items?.map(_toItemEntity).toList() ?? [],
      );

  HistoryItemEntity _toItemEntity(HistoryItemModel m) => HistoryItemEntity(
    name: m.name,
    qty: m.qty,
    isConsumable: m.isConsumable ?? false,
  );
}
