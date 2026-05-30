import 'package:json_annotation/json_annotation.dart';

part 'create_user_params.g.dart';

@JsonSerializable()
class CreateUserParams {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String email;
  final String username;
  final String password;
  @JsonKey(name: 'department_id')
  final int departmentId;
  @JsonKey(name: 'role_ids')
  final List<int> roleIds;
  final String status;

  CreateUserParams({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    required this.departmentId,
    required this.roleIds,
    required this.status,
  });
  factory CreateUserParams.fromJson(Map<String, dynamic> json) => _$CreateUserParamsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserParamsToJson(this);
}