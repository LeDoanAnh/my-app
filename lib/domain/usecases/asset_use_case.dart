import 'package:my_app/data/model/asset_detail_model.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/domain/entities/asset_detail_entity.dart';
import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/repositories/asset_repository.dart';

class AssetUseCase {
  final AssetRepository repository;

  AssetUseCase({required this.repository});

  Future<List<AssetEntity>> getActorList() async {
    return await repository.getAssetList();
  }

  Future<AssetDetailEntity> getAssetDetail(int id) async {
    return await repository.getAssetDetail(id);
  }

  Future<CreateResponse> createAsset(Map<String, dynamic> body) {
    return repository.createAsset(body);
  }
}