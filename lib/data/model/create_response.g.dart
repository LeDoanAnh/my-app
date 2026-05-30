// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateResponse _$CreateResponseFromJson(Map<String, dynamic> json) =>
    CreateResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CreateResponseToJson(CreateResponse instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};
