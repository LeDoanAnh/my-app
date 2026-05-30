import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/deparment/department_list_event.dart';
import 'package:my_app/ui/deparment/department_list_state.dart';

class DepartmentListBloc
    extends Bloc<DepartmentListEvent, DepartmentListState> {
  final DepartmentListUseCase departmentListUseCase;
  DepartmentListBloc({required this.departmentListUseCase})
    : super(DepartmentListInitial()) {
    on<GetDepartments>(_onGetDepartments);
  }

  Future<void> _onGetDepartments(
    DepartmentListEvent event,
    Emitter<DepartmentListState> emit,
  ) async {
    if (state is! DepartmentListLoading) {
      emit(DepartmentListLoading());
    }
    try {
      final departments = await departmentListUseCase.callResources();
      emit(DepartmentListLoaded(departments));
    } catch (e) {
      emit(DepartmentListError(e.toString()));
    }
  }
}
