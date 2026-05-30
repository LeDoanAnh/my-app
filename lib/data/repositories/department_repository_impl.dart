import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/domain/repositories/department_repository.dart';

class DepartmentRepositoryImpl extends DepartmentRepository {
  final AuthApi api;

  DepartmentRepositoryImpl(this.api);

  @override
  Future<List<DepartmentEntity>> getDepartmentResources() async {
    try {
      final response = await api.getDepartmentResources();
      print("response: $response");
      return response.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<DepartmentEntity> getDepartmentDetail(int id) async {
    try {
      final response = await api.getDepartmentDetail(id);
      print("response: $response");
      return response.data!.toEntity();
    } catch (e, stack) {
      print('❌ Error: $e');
      print('📍 Stack: $stack');
      print("lỗi nè");
      throw Exception("Lấy chi tiết đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<CreateResponse> createDepartment({
    required String deptName,
    required String locationDesc,
    required int? parentDeptId,
  }) async {
    final response = await api.createDepartment(
      deptName,
      locationDesc,
      parentDeptId,
    );
    return response;
  }
}
