import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/create_user_params.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository _repository;

  CreateUserUseCase(this._repository);

  Future<CreateResponse> call(CreateUserParams params) async {
    return await _repository.createUser(params.toJson());
  }

  Future<CreateResponse> update(int id, Map<String, dynamic> body) async {
    return await _repository.updateUser(id, body);
  }

  Future<CreateResponse> deactivate(int id) async {
    return await _repository.deactivateUser(id);
  }

  Future<List<RoleEntity>> getRoleList(Map<String, dynamic> body) async {
    return await _repository.getRoleList();
  }
}
