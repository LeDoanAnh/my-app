import 'package:my_app/domain/entities/role_entity.dart';

class UserEntity {
  final int id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? sessionId;
  final String? token;
  final String? departmentName;
  final List<RoleEntity>? roles;
  final int? departmentId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final int? totalSubmissions;
  final int? unreadNotifications;

  UserEntity({required this.id,  this.username, this.fullName, this.email, this.sessionId, this.token, this.roles,  this.departmentId, this.status, this.departmentName, this.createdAt, this.updatedAt, this.totalSubmissions, this.unreadNotifications});
}