import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/workflow_list_model.dart';
import 'package:my_app/domain/entities/workflow_list_entity.dart';
import 'package:my_app/domain/repositories/workflow_list_repository.dart';

class WorkflowRepositoryImpl extends WorkflowListRepository{
  final AuthApi api;

  WorkflowRepositoryImpl(this.api);

  @override
  Future<List<WorkflowListEntity>> getWorkflowList() async{
    try{
      final WorkflowListResponseModel models = await api.getWorkflowList();
      return models.data!.map((model) => model.toEntity()).toList();
    }catch(e){
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }
}