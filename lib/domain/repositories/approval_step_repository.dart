import 'package:my_app/domain/entities/approval_step_entity.dart';

abstract class ApprovalStepRepository {
  Future<ApprovalStepEntity> getApprovalStep(int id);
}
