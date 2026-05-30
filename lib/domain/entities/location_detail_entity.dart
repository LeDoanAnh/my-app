class LocationDetailEntity {
  final int id;
  final String? locationName;
  final String? capacity;
  final String? status;
  final String? deptName;
  final String? locationDesc;
  final String? address;
  final BookingEntity? currentBooking;
  final List<UpcomingEventEntity>? upcomingEvents;

  LocationDetailEntity({
    required this.id,
    this.locationName,
    this.capacity,
    this.status,
    this.deptName,
    this.locationDesc,
    this.currentBooking,
    this.address,
    this.upcomingEvents,
  });
}

class BookingEntity {
  final String? title;
  final String? time;
  final String? date;
  final String? organizer;

  BookingEntity({this.title, this.time, this.date, this.organizer});
}

class UpcomingEventEntity {
  final String? title;
  final String? date;
  UpcomingEventEntity({this.title, this.date});
}
