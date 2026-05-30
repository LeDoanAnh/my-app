import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<CreateResponse> createUser(Map<String, dynamic> body);

  Future<List<RoleEntity>> getRoleList();

  Future<UserEntity> getUserDetail(int userId);
}
