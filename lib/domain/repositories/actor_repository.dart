import 'package:my_app/domain/entities/actor_entity.dart';

abstract class ActorRepository {
  Future<List<ActorEntity>> getActorList();
}
