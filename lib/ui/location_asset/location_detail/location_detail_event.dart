abstract class LocationDetailEvent {}

class GetLocationDetail extends LocationDetailEvent {
  final int locationId;
  GetLocationDetail(this.locationId);
}
