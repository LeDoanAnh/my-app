import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/asset_detail_model.dart';
import 'package:my_app/data/model/asset_model.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/entities/asset_detail_entity.dart';
import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl extends AssetRepository {
  final AuthApi api;

  AssetRepositoryImpl(this.api);

  @override
  Future<List<AssetEntity>> getAssetList() async {
    try {
      final AssetResponseModel models = await api.getAssetList();
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<AssetDetailEntity> getAssetDetail(int id) async {
    try {
      final AssetDetailModel model = await api.getAssetDetail(id);
      return model.toEntity();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<CreateResponse> createAsset(Map<String, dynamic> body) async {
    return await api.createAsset(body);
  }
}
