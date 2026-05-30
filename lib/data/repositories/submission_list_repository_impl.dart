import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/submission_model.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/repositories/submission_list_repository.dart';

class SubmissionListRepositoryImpl extends SubmissionListRepository {
  final AuthApi api;

  SubmissionListRepositoryImpl(this.api);

  @override
  Future<List<SubmissionEntity>> getMySubmission(
    int userId,
    String type,
  ) async {
    try {
      final SubmissionResponseModel models = await api.getMySubmissions(
        userId,
        type,
      );
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<List<SubmissionEntity>> getPendingApproval(
    int userId,
    String type,
  ) async {
    try {
      final SubmissionResponseModel models = await api.getMySubmissions(
        userId,
        type,
      );
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }
}
