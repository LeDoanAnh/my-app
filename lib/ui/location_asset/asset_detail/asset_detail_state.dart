import 'package:my_app/domain/entities/asset_detail_entity.dart';

abstract class AssetDetailState {}

class AssetDetailInitial extends AssetDetailState {}

class AssetDetailLoading extends AssetDetailState {}

class AssetDetailLoaded extends AssetDetailState {
  final AssetDetailEntity asset;

  AssetDetailLoaded(this.asset);
}

class AssetDetailError extends AssetDetailState {
  final String message;

  AssetDetailError(this.message);
}
