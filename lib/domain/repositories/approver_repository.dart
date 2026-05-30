import 'package:my_app/domain/entities/approver_aubmission_entity.dart';
import 'package:my_app/data/model/create_response.dart';

abstract class ApproverRepository {
  Future<ApproverSubmissionEntity> getSubmission(int submissionId, int deptId);
  Future<CreateResponse> decide(int submissionId, Map<String, dynamic> body);
}
