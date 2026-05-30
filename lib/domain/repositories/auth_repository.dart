
import 'package:my_app/domain/entities/user_entity.dart';

abstract class AuthRepository {

  Future<UserEntity> login(String username, String password);

  Future<void> logout();

  Future<void> saveUserToLocal(UserEntity user);

  Future<UserEntity?> getUserFromLocal();

  Future<void> saveFcmToken(String token);
}