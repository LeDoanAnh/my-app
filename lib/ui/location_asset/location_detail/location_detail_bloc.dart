import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/location_use_case.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_event.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_state.dart';

class LocationDetailBloc
    extends Bloc<LocationDetailEvent, LocationDetailState> {
  final LocationUseCase useCase;

  LocationDetailBloc({required this.useCase}) : super(LocationDetailInitial()) {
    on<GetLocationDetail>(_onGetLocationDetail);
  }

  Future<void> _onGetLocationDetail(
    GetLocationDetail event,
    Emitter<LocationDetailState> emit,
  ) async {
    emit(LocationDetailLoading());
    try {
      final result = await useCase.getLocationDetail(event.locationId);
      emit(LocationDetailLoaded(result));
    } catch (e) {
      emit(LocationDetailError("Lỗi tải dữ liệu trang chủ: ${e.toString()}"));
    }
  }
}
