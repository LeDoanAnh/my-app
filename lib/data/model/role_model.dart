import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/role_entity.dart';
part 'role_model.g.dart';

@JsonSerializable()
class RoleModel {
  final int id;
  @JsonKey(name: "role_name")
  final String? roleName;
  final String? description;


  RoleModel({required this.id,this.roleName, this.description});

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  RoleEntity toEntity() {
    return RoleEntity(
      id: id,
      roleName: roleName,
      description: description,
    );
  }
}
@JsonSerializable()
class RoleResponseModel {
  final List<RoleModel>? data;

  RoleResponseModel({this.data});
  factory RoleResponseModel.fromJson(Map<String, dynamic> json) => _$RoleResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleResponseModelToJson(this);
}