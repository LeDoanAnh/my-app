import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/deparment/form_department/form_department_event.dart';
import 'package:my_app/ui/deparment/form_department/form_department_state.dart';

class FormDepartmentBloc
    extends Bloc<FormDepartmentEvent, FormDepartmentState> {
  final DepartmentListUseCase departmentListUseCase;

  FormDepartmentBloc({required this.departmentListUseCase})
    : super(FormDepartmentInitial()) {
    on<GetDepartmentList>(_onGetDepartmentList);
    on<SubmitCreateDepartment>(_onSubmitCreateDepartment);
  }
  Future<void> _onGetDepartmentList(
    GetDepartmentList event,
    Emitter<FormDepartmentState> emit,
  ) async {
    try {
      final departments = await departmentListUseCase.callResources();
      emit(FormDepartmentLoaded(departments));
    } catch (e) {
      emit(FormDepartmentError('Lỗi tải danh sách đơn vị: ${e.toString()}'));
    }
  }

  // ── Submit tạo phòng ban mới ───────────────────────────────────────────────
  Future<void> _onSubmitCreateDepartment(
    SubmitCreateDepartment event,
    Emitter<FormDepartmentState> emit,
  ) async {
    List departments = [];
    final currentState = state;
    if (currentState is FormDepartmentLoaded) {
      departments = currentState.departments;
    }

    emit(FormDepartmentLoading());

    try {
      final response = await departmentListUseCase.createDepartment(
        event.deptName!,
        event.locationDesc!,
        event.parentDeptId,
      );

      if (response.success) {
        emit(FormDepartmentSuccess(response.message));
      } else {
        emit(FormDepartmentError(response.message));
      }
    } catch (e) {
      if (e is DioException) {
        emit(
          FormDepartmentError(
            e.response?.data?['message'] ??
                'Lỗi kết nối. Vui lòng kiểm tra mạng.',
          ),
        );
      } else {
        emit(FormDepartmentError('Lỗi không xác định: ${e.toString()}'));
      }
    }
  }
}
