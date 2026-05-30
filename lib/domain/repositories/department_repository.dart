import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';

abstract class DepartmentRepository {
  Future<List<DepartmentEntity>> getDepartmentResources();

  Future<DepartmentEntity> getDepartmentDetail(int id);

  Future<CreateResponse> createDepartment({
    required String deptName,
    required String locationDesc,
    required int? parentDeptId,
  });
}
