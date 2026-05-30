import '../entities/submission_entity.dart';
import '../entities/submission_stats_entity.dart';
import '../repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  Future<SubmissionStatsEntity> getStats(int userId) async {
    return await repository.getSubmissionStats(userId);
  }

  Future<List<SubmissionEntity>> getRecent(int userId) async {
    return await repository.getRecentSubmissions(userId);
  }
}
