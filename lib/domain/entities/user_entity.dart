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
  final bool isFirstLogin;

  UserEntity({
    required this.id,
    this.username,
    this.fullName,
    this.email,
    this.sessionId,
    this.token,
    this.roles,
    this.departmentId,
    this.status,
    this.departmentName,
    this.createdAt,
    this.updatedAt,
    this.totalSubmissions,
    this.unreadNotifications,
    this.isFirstLogin = false,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    String? fullName,
    String? email,
    String? sessionId,
    String? token,
    String? departmentName,
    List<RoleEntity>? roles,
    int? departmentId,
    String? status,
    String? createdAt,
    String? updatedAt,
    int? totalSubmissions,
    int? unreadNotifications,
    bool? isFirstLogin,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      sessionId: sessionId ?? this.sessionId,
      token: token ?? this.token,
      departmentName: departmentName ?? this.departmentName,
      roles: roles ?? this.roles,
      departmentId: departmentId ?? this.departmentId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }
}
