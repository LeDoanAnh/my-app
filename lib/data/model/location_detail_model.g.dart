// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDetailModel _$LocationDetailModelFromJson(Map<String, dynamic> json) =>
    LocationDetailModel(
      id: (json['id'] as num).toInt(),
      locationName: json['location_name'] as String?,
      capacity: json['capacity'] as String?,
      status: json['status'] as String?,
      deptName: json['dept_name'] as String?,
      address: json['address'] as String?,
      locationDesc: json['location_desc'] as String?,
      currentBooking: json['current_booking'] == null
          ? null
          : BookingModel.fromJson(
              json['current_booking'] as Map<String, dynamic>,
            ),
      upcomingEvents: (json['upcoming_events'] as List<dynamic>?)
          ?.map((e) => UpcomingEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationDetailModelToJson(
  LocationDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'location_name': instance.locationName,
  'capacity': instance.capacity,
  'status': instance.status,
  'dept_name': instance.deptName,
  'location_desc': instance.locationDesc,
  'address': instance.address,
  'current_booking': instance.currentBooking,
  'upcoming_events': instance.upcomingEvents,
};

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  title: json['title'] as String?,
  time: json['time'] as String?,
  date: json['date'] as String?,
  organizer: json['organizer'] as String?,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'date': instance.date,
      'organizer': instance.organizer,
    };

UpcomingEventModel _$UpcomingEventModelFromJson(Map<String, dynamic> json) =>
    UpcomingEventModel(
      title: json['title'] as String?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$UpcomingEventModelToJson(UpcomingEventModel instance) =>
    <String, dynamic>{'title': instance.title, 'date': instance.date};
