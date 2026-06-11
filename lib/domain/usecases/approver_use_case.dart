// domain/usecases/approver_use_case.dart
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/entities/approver_aubmission_entity.dart';
import 'package:my_app/domain/repositories/approver_repository.dart';

class ApproverUseCase {
  final ApproverRepository repository;
  ApproverUseCase({required this.repository});

  Future<ApproverSubmissionEntity> getSubmission(int submissionId, int deptId) {
    return repository.getSubmission(submissionId, deptId);
  }

  Future<CreateResponse> decide(
    int submissionId, {
    required int approverId,
    required String action,
    required String password,
    String? comment,
  }) {
    return repository.decide(submissionId, {
      'approver_id': approverId,
      'action': action,
      'password': password,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }

  Future<CreateResponse> preSign(
    int submissionId, {
    required int staffId,
    required String action,
    String? comment,
    List<String> attachmentPaths = const [],
  }) {
    return repository.preSign(
      submissionId,
      staffId: staffId,
      action: action,
      comment: comment,
      attachmentPaths: attachmentPaths,
    );
  }
}
