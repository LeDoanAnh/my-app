// domain/repositories/borrow_repository.dart
import 'package:my_app/data/model/borrow_model.dart';
import 'package:my_app/domain/entities/borrow_entity.dart';

abstract class BorrowRepository {
  Future<List<BorrowEntity>> getBorrowList(int userId, {String? search});
  Future<BorrowActionResponse> confirmReceive(int submissionId, int userId);
  Future<BorrowActionResponse> returnAssets(
    int submissionId,
    int userId,
    List<int> assetRequestIds,
  );
}
