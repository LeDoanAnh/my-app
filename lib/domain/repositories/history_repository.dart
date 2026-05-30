import 'package:my_app/domain/entities/history_entity.dart';

abstract class HistoryRepository {
  Future<List<BorrowHistoryEntity>> getBorrowHistory(
    int userId, {
    String? search,
  });
  Future<List<HandoverHistoryEntity>> getHandoverHistory(
    int userId, {
    String? search,
  });
}
