import 'package:my_app/domain/entities/workflow_list_entity.dart';
import 'package:my_app/data/model/create_response.dart';

abstract class WorkflowListRepository {
  Future<List<WorkflowListEntity>> getWorkflowList();
  Future<CreateResponse> createWorkflow(Map<String, dynamic> body);
  Future<CreateResponse> updateWorkflow(int id, Map<String, dynamic> body);
}
