import 'package:my_app/domain/entities/actor_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/domain/repositories/actor_repository.dart';
import 'package:my_app/domain/repositories/user_repository.dart';

class ActorUseCase {
  final ActorRepository repository;
  final UserRepository userRepository;

  ActorUseCase(this.repository, this.userRepository);

  Future<List<ActorEntity>> getActorList() async {
    return await repository.getActorList();
  }

  Future<UserEntity> call(int id) async {
    return await userRepository.getUserDetail(id);
  }
}
