import 'package:my_app/domain/entities/submission_stats_entity.dart';
import 'package:my_app/domain/entities/submission_step.dart';
import 'package:my_app/domain/repositories/submission_detail_repository.dart';

class SubmissionDetailUseCase {
  final SubmissionDetailRepository repository;

  SubmissionDetailUseCase({required this.repository});

  Future<SubmissionStep> getStatistics(int userId) async {
    return await repository.getStatistics(userId);
  }
}
