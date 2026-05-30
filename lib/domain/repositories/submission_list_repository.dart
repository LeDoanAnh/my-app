import 'package:my_app/domain/entities/submission_entity.dart';

abstract class SubmissionListRepository {

  Future <List<SubmissionEntity>> getMySubmission(int userId, String type);

  Future<List<SubmissionEntity>> getPendingApproval(int userId, String type);

}