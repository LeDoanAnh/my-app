import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/location_detail_entity.dart';

part 'location_detail_model.g.dart';

@JsonSerializable()
class LocationDetailModel {
  final int id;
  @JsonKey(name: 'location_name')
  final String? locationName;
  final String? capacity;
  final String? status;
  @JsonKey(name: 'dept_name')
  final String? deptName;
  @JsonKey(name: 'location_desc')
  final String? locationDesc;
  final String? address;
  @JsonKey(name: 'current_booking')
  final BookingModel? currentBooking;
  @JsonKey(name: 'upcoming_events')
  final List<UpcomingEventModel>? upcomingEvents;

  LocationDetailModel({
    required this.id,
    this.locationName,
    this.capacity,
    this.status,
    this.deptName,
    this.address,
    this.locationDesc,
    this.currentBooking,
    this.upcomingEvents,
  });

  factory LocationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailModelToJson(this);

  LocationDetailEntity toEntity(){
    return LocationDetailEntity(
      id: id,
      locationName: locationName,
      capacity: capacity,
      status: status,
      deptName: deptName,
      locationDesc: locationDesc,
      address: address,
      currentBooking: currentBooking?.toEntity(),
      upcomingEvents: upcomingEvents?.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class BookingModel {
  final String? title;
  final String? time;
  final String? date;
  final String? organizer;

  BookingModel({this.title, this.time, this.date, this.organizer});

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  BookingEntity toEntity(){
    return BookingEntity(
      title: title,
      time: time,
      date: date,
      organizer: organizer,
    );
  }
}

@JsonSerializable()
class UpcomingEventModel {
  final String? title;
  final String? date;

  UpcomingEventModel({this.title, this.date});

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpcomingEventModelToJson(this);

  UpcomingEventEntity toEntity(){
    return UpcomingEventEntity(
      title: title,
      date: date,
    );
  }
}

