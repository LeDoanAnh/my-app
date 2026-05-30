import 'package:my_app/domain/entities/role_entity.dart';

abstract class SubmissionListEvent {}

class FetchSubmissionList extends SubmissionListEvent {
  final int userId;
  final List<RoleEntity> roles;

  FetchSubmissionList({required this.userId, required this.roles});
}
