import 'package:my_app/domain/entities/create_submission_params.dart';

abstract class SubmissionRepository {
  Future<Map<String, dynamic>> createSubmission({
    required String title,
    required int workflowId,
    required String startDate,
    required String endDate,
    required int creatorId,
    String? description,
    required String departmentsJson,
    required List<FileAttachment> attachments,
  });
}
