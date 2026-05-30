import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/workflow_list_entity.dart';

part 'workflow_list_model.g.dart';

@JsonSerializable()
class WorkflowListModel {
  final int id;
  final String? name;
  final String? description;
  @JsonKey(name: "apply_to")
  final String? applyTo;
  @JsonKey(name: "steps_count")
  final int? stepsCount;
  final String? status;
  final List<String>? steps;

  WorkflowListModel({
    required this.id,
    this.name,
    this.description,
    this.applyTo,
    this.stepsCount,
    this.status,
    this.steps
  });

  factory WorkflowListModel.fromJson(Map<String, dynamic> json) => _$WorkflowListModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowListModelToJson(this);

  WorkflowListEntity toEntity() {
    return WorkflowListEntity(
      id: id,
      name: name,
      description: description,
      stepsCount: stepsCount,
      applyTo: applyTo,
      status: status,
      steps: steps
    );
  }

}

@JsonSerializable()
class WorkflowListResponseModel{
  final List<WorkflowListModel> data;

  WorkflowListResponseModel({
    required this.data
  });

  factory WorkflowListResponseModel.fromJson(Map<String, dynamic> json) => _$WorkflowListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowListResponseModelToJson(this);
}
