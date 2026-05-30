import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/asset_use_case.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_event.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_state.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final AssetUseCase useCase;

  AssetDetailBloc({required this.useCase}) : super(AssetDetailInitial()) {
    on<GetAssetDetail>(_getAssetDetail);
  }

  Future<void> _getAssetDetail(
    GetAssetDetail event,
    Emitter<AssetDetailState> emit,
  ) async {
    emit(AssetDetailLoading());
    try {
      final result = await useCase.getAssetDetail(event.id);
      return emit(AssetDetailLoaded(result));
    } catch (e) {
      emit(AssetDetailError("Lỗi tải dữ liệu trang chủ: ${e.toString()}"));
    }
  }
}
