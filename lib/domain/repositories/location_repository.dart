import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/domain/entities/location_detail_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<List<LocationEntity>> getLocationList();

  Future<LocationDetailEntity> getLocationDetail(int locationId);

  Future<CreateResponse> createLocation(Map<String, dynamic> body);
}
