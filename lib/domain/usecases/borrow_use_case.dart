// domain/usecases/borrow_use_case.dart
import 'package:my_app/data/model/borrow_model.dart';
import 'package:my_app/domain/entities/borrow_entity.dart';
import 'package:my_app/domain/repositories/borrow_repository.dart';

class BorrowUseCase {
  final BorrowRepository repository;
  BorrowUseCase({required this.repository});

  Future<List<BorrowEntity>> getBorrowList(int userId, {String? search}) {
    return repository.getBorrowList(userId, search: search);
  }

  Future<BorrowActionResponse> confirmReceive(int submissionId, int userId) {
    return repository.confirmReceive(submissionId, userId);
  }

  Future<BorrowActionResponse> returnAssets(
      int submissionId, int userId, List<int> assetRequestIds) {
    return repository.returnAssets(submissionId, userId, assetRequestIds);
  }
}