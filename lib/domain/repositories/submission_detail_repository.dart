import 'package:my_app/domain/entities/submission_step.dart';

abstract class SubmissionDetailRepository {

  Future<SubmissionStep> getStatistics(int userId);

}