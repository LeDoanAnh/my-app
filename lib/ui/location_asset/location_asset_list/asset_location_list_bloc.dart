import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';
import 'package:my_app/domain/usecases/asset_use_case.dart';
import 'package:my_app/domain/usecases/location_use_case.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_event.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_state.dart';

class AssetLocationListBloc
    extends Bloc<AssetLocationListEvent, AssetLocationListState> {
  final AssetUseCase assetUseCase;
  final LocationUseCase locationUseCase;

  List<AssetEntity> _allAssets = [];
  List<LocationEntity> _allLocations = [];

  AssetLocationListBloc({
    required this.assetUseCase,
    required this.locationUseCase,
  }) : super(AssetLocationListInitial()) {
    on<GetAssetLocationList>(_getAssetList);
    on<SearchResourceEvent>(_onSearch);
  }
  Future<void> _getAssetList(
    GetAssetLocationList event,
    Emitter<AssetLocationListState> emit,
  ) async {
    if (state is! AssetLocationListLoaded) {
      emit(AssetLocationListLoading());
    }
    try {
      _allAssets = await assetUseCase.getActorList();
      _allLocations = await locationUseCase.getLocationList();

      emit(AssetLocationListLoaded(_allAssets, _allLocations));
    } catch (e) {
      emit(AssetLocationListError("Lỗi tải dữ liệu: ${e.toString()}"));
    }
  }

  void _onSearch(
    SearchResourceEvent event,
    Emitter<AssetLocationListState> emit,
  ) {
    final query = event.query.toLowerCase();

    final filteredAssets = _allAssets.where((asset) {
      final name = asset.assetName?.toLowerCase() ?? "";
      final code = asset.assetCode?.toLowerCase() ?? "";
      return name.contains(query) || code.contains(query);
    }).toList();

    final filteredLocations = _allLocations.where((loc) {
      final name = loc.locationName?.toLowerCase() ?? "";
      return name.contains(query);
    }).toList();

    emit(AssetLocationListLoaded(filteredAssets, filteredLocations));
  }
}
