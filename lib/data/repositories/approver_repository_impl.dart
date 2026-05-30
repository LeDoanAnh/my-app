// data/repositories/approver_repository_impl.dart
import 'package:my_app/data/api/api.dart';
import 'package:my_app/domain/entities/approver_aubmission_entity.dart';
import 'package:my_app/domain/repositories/approver_repository.dart';
import 'package:my_app/data/model/create_response.dart';

class ApproverRepositoryImpl extends ApproverRepository {
  final AuthApi api;
  ApproverRepositoryImpl(this.api);

  @override
  Future<ApproverSubmissionEntity> getSubmission(int submissionId, int deptId) async {
    try {
      final response = await api.getApproverSubmission(submissionId, deptId);
      print("RAW RESPONSE: ${response}");
      final d = response.data!;
      return ApproverSubmissionEntity(
        id: d.id,
        title: d.title,
        content: d.content,
        status: d.status,
        sender: d.sender,
        startTime: d.startTime,
        endTime: d.endTime,
        noteForDept: d.noteForDept,
        locations: d.locations?.map((l) => ApproverLocationEntity(
          locationName: l.locationName,
          startTime: l.startTime,
          endTime: l.endTime,
        )).toList(),
        assets: d.assets?.map((a) => ApproverAssetEntity(
          assetName: a.assetName,
          quantity: a.quantity,
        )).toList(),
        myDecision: d.myDecision == null ? null : MyDecisionEntity(
          action: d.myDecision!.action,
          comment: d.myDecision!.comment,
          decidedAt: d.myDecision!.decidedAt,
        ),
      );
    } catch (e) {
      throw Exception("Lấy thông tin tờ trình thất bại: ${e.toString()}");
    }
  }

  @override
  Future<CreateResponse> decide(int submissionId, Map<String, dynamic> body) async {
    return await api.decideSubmission(submissionId, body);
  }
}