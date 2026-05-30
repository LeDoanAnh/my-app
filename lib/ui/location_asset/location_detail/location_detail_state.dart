import 'package:my_app/domain/entities/location_detail_entity.dart';

abstract class LocationDetailState {}

class LocationDetailInitial extends LocationDetailState {}

class LocationDetailLoading extends LocationDetailState {}

class LocationDetailLoaded extends LocationDetailState {
  final LocationDetailEntity locationDetail;

  LocationDetailLoaded(this.locationDetail);
}

class LocationDetailError extends LocationDetailState {
  final String errorMessage;

  LocationDetailError(this.errorMessage);
}
