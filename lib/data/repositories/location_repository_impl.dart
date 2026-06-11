import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/location_detail_model.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/domain/entities/location_detail_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';
import 'package:my_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl extends LocationRepository {
  final AuthApi api;

  LocationRepositoryImpl(this.api);

  @override
  Future<List<LocationEntity>> getLocationList() async {
    try {
      final LocationResponseModel models = await api.getLocationList();
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<LocationDetailEntity> getLocationDetail(int locationId) async {
    try {
      final LocationDetailModel model = await api.getLocationDetail(locationId);
      return model.toEntity();
    } catch (e) {
      throw Exception("Lấy chi tiết đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<CreateResponse> createLocation(Map<String, dynamic> body) async {
    return await api.createLocation(body);
  }

  @override
  Future<CreateResponse> updateLocation(
    int id,
    Map<String, dynamic> body,
  ) async {
    return await api.updateLocation(id, body);
  }
}
