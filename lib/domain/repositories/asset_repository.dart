import 'package:my_app/data/model/asset_detail_model.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/entities/asset_detail_entity.dart';
import 'package:my_app/domain/entities/asset_entity.dart';

abstract class AssetRepository {

  Future<List<AssetEntity>> getAssetList();

  Future<AssetDetailEntity> getAssetDetail(int id);

  Future<CreateResponse> createAsset(Map<String, dynamic> body);
}