import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';

abstract class AssetLocationListState {}

class AssetLocationListInitial extends AssetLocationListState {}

class AssetLocationListLoading extends AssetLocationListState {}

class AssetLocationListLoaded extends AssetLocationListState {
  final List<AssetEntity> assets;
  final List<LocationEntity> locations;

  AssetLocationListLoaded(this.assets, this.locations);
}

class AssetLocationListError extends AssetLocationListState {
  final String message;

  AssetLocationListError(this.message);
}
