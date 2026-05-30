import 'package:my_app/domain/entities/history_entity.dart';
import 'package:my_app/domain/repositories/history_repository.dart';

class HistoryUseCase {
  final HistoryRepository repository;
  HistoryUseCase({required this.repository});

  Future<List<BorrowHistoryEntity>> getBorrowHistory(
    int userId, {
    String? search,
  }) => repository.getBorrowHistory(userId, search: search);

  Future<List<HandoverHistoryEntity>> getHandoverHistory(
    int userId, {
    String? search,
  }) => repository.getHandoverHistory(userId, search: search);
}
