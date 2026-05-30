import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/repositories/submission_list_repository.dart';

class SubmissionListUseCase {
  final SubmissionListRepository repository;
  SubmissionListUseCase({required this.repository});

  Future<List<SubmissionEntity>> callMySubmission(
    int userId,
    String type,
  ) async {
    return await repository.getMySubmission(userId, type);
  }

  Future<List<SubmissionEntity>> callPendingApproval(
    int userId,
    String type,
  ) async {
    return await repository.getPendingApproval(userId, type);
  }
}
