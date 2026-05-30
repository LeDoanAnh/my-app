import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  Future<UserEntity> call(String username, String password){
    return repository.login(username, password);
  }
}