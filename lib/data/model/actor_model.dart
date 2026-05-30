import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/domain/entities/actor_entity.dart';

part 'actor_model.g.dart';

@JsonSerializable()
class ActorModel {
  final int id;
  @JsonKey(name: 'actor_id')
  final int? actorId;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final DepartmentModel? department;

  ActorModel({required this.id, this.fullName, this.department, this.actorId});

  factory ActorModel.fromJson(Map<String, dynamic> json) => _$ActorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActorModelToJson(this);

  ActorEntity toEntity(){
    return ActorEntity(
      id: id,
      fullName: fullName,
      department: department?.toEntity(),
    );
  }
}

@JsonSerializable()
class ActorResponseModel {
  final List<ActorModel>? data;

  ActorResponseModel({this.data});

  factory ActorResponseModel.fromJson(Map<String, dynamic> json) => _$ActorResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActorResponseModelToJson(this);
}
