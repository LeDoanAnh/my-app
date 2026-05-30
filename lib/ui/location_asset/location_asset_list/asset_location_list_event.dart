abstract class AssetLocationListEvent {}

class GetAssetLocationList extends AssetLocationListEvent {
  GetAssetLocationList();
}

class SearchResourceEvent extends AssetLocationListEvent {
  final String query;
  SearchResourceEvent(this.query);
}
