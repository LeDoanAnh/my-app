// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkflowListModel _$WorkflowListModelFromJson(Map<String, dynamic> json) =>
    WorkflowListModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      applyTo: json['apply_to'] as String?,
      stepsCount: (json['steps_count'] as num?)?.toInt(),
      status: json['status'] as String?,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkflowListModelToJson(WorkflowListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'apply_to': instance.applyTo,
      'steps_count': instance.stepsCount,
      'status': instance.status,
      'steps': instance.steps,
    };

WorkflowListResponseModel _$WorkflowListResponseModelFromJson(
  Map<String, dynamic> json,
) => WorkflowListResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => WorkflowListModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkflowListResponseModelToJson(
  WorkflowListResponseModel instance,
) => <String, dynamic>{'data': instance.data};
