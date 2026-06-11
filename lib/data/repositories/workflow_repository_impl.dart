import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/workflow_list_model.dart';
import 'package:my_app/domain/entities/workflow_list_entity.dart';
import 'package:my_app/domain/repositories/workflow_list_repository.dart';

class WorkflowRepositoryImpl extends WorkflowListRepository {
  final AuthApi api;

  WorkflowRepositoryImpl(this.api);

  @override
  Future<List<WorkflowListEntity>> getWorkflowList() async {
    try {
      final WorkflowListResponseModel models = await api.getWorkflowList();
      return models.data.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Lấy danh sách luồng duyệt thất bại: ${e.toString()}');
    }
  }

  @override
  Future<CreateResponse> createWorkflow(Map<String, dynamic> body) {
    return api.createWorkflow(body);
  }

  @override
  Future<CreateResponse> updateWorkflow(int id, Map<String, dynamic> body) {
    return api.updateWorkflow(id, body);
  }
}
