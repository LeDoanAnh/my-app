import 'package:my_app/domain/entities/approval_step_entity.dart';
import 'package:my_app/domain/repositories/approval_step_repository.dart';

class ApprovalStepUseCase {
  final ApprovalStepRepository repository;

  ApprovalStepUseCase({required this.repository});

  Future<ApprovalStepEntity> getApprovalStep(int id) async {
    return await repository.getApprovalStep(id);
  }
}
