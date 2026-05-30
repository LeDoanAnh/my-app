import 'package:my_app/data/api/api.dart';
import 'package:my_app/domain/entities/actor_entity.dart';
import 'package:my_app/domain/repositories/actor_repository.dart';

class ActorRepositoryImpl extends ActorRepository {
  final AuthApi api;

  ActorRepositoryImpl(this.api);

  @override
  Future<List<ActorEntity>> getActorList() async {
    try {
      final response = await api.getActorList();
      return response.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }
}
