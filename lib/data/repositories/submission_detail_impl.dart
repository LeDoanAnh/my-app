import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/submission_stats_model.dart';
import 'package:my_app/data/model/submission_step_model.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';
import 'package:my_app/domain/entities/submission_step.dart';
import 'package:my_app/domain/repositories/submission_detail_repository.dart';

class SubmissionDetailImpl extends SubmissionDetailRepository {
  final AuthApi api;
  SubmissionDetailImpl({required this.api});

  @override
  Future<SubmissionStep> getStatistics(int userId) async {
    try {
      final SubmissionStepModel model = await api.getSubmissionDetail(userId);
      return model.toEntity();
    } catch (e) {
      throw Exception("Lấy thống kê đơn thất bại: ${e.toString()}");
    }
  }
}
