import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/asset_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/domain/usecases/location_use_case.dart';
import 'package:my_app/ui/location_asset/form_resource_event.dart';
import 'package:my_app/ui/location_asset/form_resource_state.dart';

class FormResourceBloc extends Bloc<FormResourceEvent, FormResourceState> {
  final DepartmentListUseCase departmentListUseCase;
  final LocationUseCase locationUseCase;
  final AssetUseCase assetUseCase;

  FormResourceBloc({
    required this.departmentListUseCase,
    required this.locationUseCase,
    required this.assetUseCase,
  }) : super(FormResourceInitial()) {
    on<GetDepartmentList>(_onGetDepartmentList);
    on<SubmitCreateLocation>(_onSubmitCreateLocation);
    on<SubmitCreateAsset>(_onSubmitCreateAsset);
  }

  Future<void> _onGetDepartmentList(
    GetDepartmentList event,
    Emitter<FormResourceState> emit,
  ) async {
    try {
      final departments = await departmentListUseCase.callResources();
      emit(FormResourceLoaded(departments));
    } catch (e) {
      emit(
        FormResourceError(
          'Lỗi tải danh sách đơn vị: ${e.toString()}',
          departments: state.departments,
        ),
      );
    }
  }

  Future<void> _onSubmitCreateLocation(
    SubmitCreateLocation event,
    Emitter<FormResourceState> emit,
  ) async {
    final currentDepts = state.departments;
    emit(FormResourceLoading(departments: currentDepts));
    try {
      final response = await locationUseCase.createLocation({
        'name': event.name!,
        'capacity': event.capacity!,
        'address': event.address!,
        'dept_id': event.deptId!,
      });
      if (response.success) {
        emit(FormResourceSuccess(response.message, departments: currentDepts));
      } else {
        emit(FormResourceError(response.message, departments: currentDepts));
      }
    } catch (e) {
      String errorMessage = 'Lỗi không xác định: ${e.toString()}';
      if (e is DioException) {
        errorMessage = 'Lỗi kết nối. Vui lòng kiểm tra mạng.';
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data!;
        }
      }
      emit(FormResourceError(errorMessage, departments: currentDepts));
    }
  }

  Future<void> _onSubmitCreateAsset(
    SubmitCreateAsset event,
    Emitter<FormResourceState> emit,
  ) async {
    final currentDepts = state.departments;
    emit(FormResourceLoading(departments: currentDepts));
    try {
      final response = await assetUseCase.createAsset({
        'name': event.name!,
        'description': event.description!,
        'unit': event.unit!,
        'asset_type': event.assetType!,
        'dept_id': event.deptId!,
      });
      if (response.success) {
        emit(FormResourceSuccess(response.message, departments: currentDepts));
      } else {
        emit(FormResourceError(response.message, departments: currentDepts));
      }
    } catch (e) {
      String errorMessage = 'Lỗi không xác định: ${e.toString()}';
      if (e is DioException) {
        errorMessage = 'Lỗi kết nối. Vui lòng kiểm tra mạng.';
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data!;
        }
      }
      emit(FormResourceError(errorMessage, departments: currentDepts));
    }
  }
}
