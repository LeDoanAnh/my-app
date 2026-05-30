import 'package:my_app/domain/entities/department_entity.dart';

class ActorEntity {
  final int id;
  final String? fullName;
  final DepartmentEntity? department;

  ActorEntity({required this.id, this.fullName, this.department});
}