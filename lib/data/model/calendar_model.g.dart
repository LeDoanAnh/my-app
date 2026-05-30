// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarModel _$CalendarModelFromJson(Map<String, dynamic> json) =>
    CalendarModel(
      title: json['title'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      time: json['time'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$CalendarModelToJson(CalendarModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'status': instance.status,
      'time': instance.time,
      'color': instance.color,
    };

CalendarResponseModel _$CalendarResponseModelFromJson(
  Map<String, dynamic> json,
) => CalendarResponseModel(
  data: (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => CalendarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$CalendarResponseModelToJson(
  CalendarResponseModel instance,
) => <String, dynamic>{'data': instance.data};
