import 'package:my_app/domain/entities/workflow_list_entity.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/repositories/workflow_list_repository.dart';

class WorkflowListUseCase {
  final WorkflowListRepository repository;

  WorkflowListUseCase({required this.repository});

  Future<List<WorkflowListEntity>> callWorkflowList() async {
    return await repository.getWorkflowList();
  }

  Future<CreateResponse> createWorkflow(Map<String, dynamic> body) async {
    return await repository.createWorkflow(body);
  }

  Future<CreateResponse> updateWorkflow(
    int id,
    Map<String, dynamic> body,
  ) async {
    return await repository.updateWorkflow(id, body);
  }
}
