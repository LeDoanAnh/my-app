import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';

abstract class HomeRepository {

  Future<SubmissionStatsEntity> getSubmissionStats(int userId);

  Future<List<SubmissionEntity>> getRecentSubmissions(int userId);
}