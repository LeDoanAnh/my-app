import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/domain/entities/location_detail_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';
import 'package:my_app/domain/repositories/location_repository.dart';

class LocationUseCase {
  final LocationRepository repository;

  LocationUseCase({required this.repository});

  Future<List<LocationEntity>> getLocationList() async {
    return await repository.getLocationList();
  }

  Future<LocationDetailEntity> getLocationDetail(int locationId) async {
    return await repository.getLocationDetail(locationId);
  }

  Future<CreateResponse> createLocation(Map<String, dynamic> body) {
    return repository.createLocation(body);
  }
}
