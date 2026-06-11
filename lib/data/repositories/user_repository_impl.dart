import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/create_user_response.dart';
import 'package:my_app/data/model/role_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApi _authApi;

  UserRepositoryImpl(this._authApi);

  @override
  Future<CreateResponse> createUser(Map<String, dynamic> body) async {
    return await _authApi.createUser(body);
  }

  @override
  Future<CreateResponse> updateUser(int id, Map<String, dynamic> body) async {
    return await _authApi.updateUser(id, body);
  }

  @override
  Future<CreateResponse> deactivateUser(int id) async {
    return await _authApi.deactivateUser(id);
  }

  @override
  Future<List<RoleEntity>> getRoleList() async {
    try {
      final RoleResponseModel models = await _authApi.getRoleList();
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<UserEntity> getUserDetail(int userId) async {
    try {
      final UserResponse response = await _authApi.getActorDetail(userId);
      return response.data!.toEntity();
    } catch (e) {
      throw Exception("Lấy thông tin người dùng thất bại: ${e.toString()}");
    }
  }
}
