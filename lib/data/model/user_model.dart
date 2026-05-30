import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/role_model.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String? username;
  @JsonKey(name: "full_name")
  final String? fullName;
  final String? email;
  @JsonKey(name: "session_id")
  final String? sessionId;
  final String? token;
  final List<RoleModel>? roles;
  @JsonKey(name: "department_id")
  final int? departmentId;
  @JsonKey(name: "department_name")
  final String? departmentName;
  final String? status;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "total_submissions")
  final int? totalSubmissions;
  @JsonKey(name: "unread_notifications")
  final int? unreadNotifications;



  UserModel({
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      fullName: fullName,
      email: email,
      sessionId: sessionId ?? "",
      token: token,
      status: status,
      roles: roles?.map((roleModel) => RoleEntity(
          id: roleModel.id,
          roleName: roleModel.roleName,
          description: roleModel.description
      )).toList() ?? [],
      departmentId: departmentId,
      departmentName: departmentName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalSubmissions: totalSubmissions,
      unreadNotifications: unreadNotifications,
    );
  }
}

@JsonSerializable()
class UserResponse {
  final UserModel? data;

  UserResponse({
    this.data,
  });
  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}