abstract class AssetDetailEvent {}

class GetAssetDetail extends AssetDetailEvent {
  final int id;

  GetAssetDetail(this.id);
}
