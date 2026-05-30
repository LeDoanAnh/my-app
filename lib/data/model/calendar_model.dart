import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/calendar_entity.dart';

part 'calendar_model.g.dart';

@JsonSerializable()
class CalendarModel {
  final String? title;
  final String? type;
  final String? status;
  final String? time;
  final String? color;

  CalendarModel({this.title, this.type, this.status, this.time, this.color});

  factory CalendarModel.fromJson(Map<String, dynamic> json) => _$CalendarModelFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);

  CalendarEntity toEntity(DateTime eventDate){
    return CalendarEntity(
      title: title ?? '',
      type: type ?? '',
      status: status ?? '',
      time: time ?? '',
      color: color ?? "warning",
      date: eventDate,
    );
  }
}

@JsonSerializable()
class CalendarResponseModel {
  final Map<String, List<CalendarModel>>? data;

  CalendarResponseModel({ required this.data});

  factory CalendarResponseModel.fromJson(Map<String, dynamic> json) => _$CalendarResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarResponseModelToJson(this);

}