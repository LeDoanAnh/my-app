import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/submission_model.dart';
import 'package:my_app/data/model/submission_stats_model.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';
import 'package:my_app/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final AuthApi api;

  HomeRepositoryImpl(this.api);

  @override
  Future<SubmissionStatsEntity> getSubmissionStats(int userId) async {
    try {
      final SubmissionStatsModel statsModel = await api.getStatistics(userId);
      return statsModel.toEntity();
    } catch (e) {
      throw Exception("Lấy thống kê thất bại: ${e.toString()}");
    }
  }

  @override
  Future<List<SubmissionEntity>> getRecentSubmissions(int userId) async {
    try {
      final List<SubmissionModel> models = await api.getRecentSubmissions(userId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách tờ trình thất bại: ${e.toString()}");
    }
  }
}