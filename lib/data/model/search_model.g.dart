// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) =>
    SearchResultModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String?,
      refId: (json['ref_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'status': instance.status,
      'ref_id': instance.refId,
    };

SearchListResponse _$SearchListResponseFromJson(Map<String, dynamic> json) =>
    SearchListResponse(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchListResponseToJson(SearchListResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};
