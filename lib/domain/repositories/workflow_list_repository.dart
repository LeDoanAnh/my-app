import 'package:my_app/domain/entities/workflow_list_entity.dart';

abstract class WorkflowListRepository {
  Future<List<WorkflowListEntity>> getWorkflowList();
}
