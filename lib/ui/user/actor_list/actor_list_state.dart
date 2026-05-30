import 'package:my_app/domain/entities/actor_entity.dart';
import 'package:my_app/domain/entities/department_entity.dart';

abstract class ActorListState {}

class ActorListInitial extends ActorListState {}

class ActorListLoading extends ActorListState {}

class ActorListLoaded extends ActorListState {
  final List<ActorEntity> actors;
  final List<DepartmentEntity> departments;

  ActorListLoaded(this.actors, this.departments);
}

class ActorListError extends ActorListState {
  final String message;

  ActorListError(this.message);
}
