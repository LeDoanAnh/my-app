import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/domain/repositories/department_repository.dart';

class DepartmentListUseCase {
  final DepartmentRepository repository;

  DepartmentListUseCase({required this.repository});

  Future<List<DepartmentEntity>> callResources() async {
    return await repository.getDepartmentResources();
  }

  Future<DepartmentEntity> callDetail(int id) async {
    return await repository.getDepartmentDetail(id);
  }

  Future<CreateResponse> createDepartment(
    String deptName,
    String locationDesc,
    int? parentDeptId,
    String status,
  ) async {
    return await repository.createDepartment(
      deptName: deptName,
      locationDesc: locationDesc,
      parentDeptId: parentDeptId,
      status: status,
    );
  }

  Future<CreateResponse> updateDepartment(
    int id,
    Map<String, dynamic> body,
  ) async {
    return await repository.updateDepartment(id, body);
  }

  Future<CreateResponse> deactivateDepartment(int id) async {
    return await repository.deactivateDepartment(id);
  }
}
