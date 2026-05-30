import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/approval_step_model.dart';
import 'package:my_app/domain/entities/approval_step_entity.dart';
import 'package:my_app/domain/repositories/approval_step_repository.dart';

class ApprovalStepRepositoryImpl extends ApprovalStepRepository {
  final AuthApi api;

  ApprovalStepRepositoryImpl(this.api);

  @override
  Future<ApprovalStepEntity> getApprovalStep(int id) async {
    try {
      final WorkflowDetail model = await api.getWorkflowDetail(id);
      return model.data.toEntity();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại $e");
    }
  }
}
