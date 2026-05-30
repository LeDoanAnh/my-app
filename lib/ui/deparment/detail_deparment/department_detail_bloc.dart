import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_event.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_state.dart';

class DepartmentDetailBloc
    extends Bloc<DepartmentDetailEvent, DepartmentDetailState> {
  final DepartmentListUseCase useCase;
  DepartmentDetailBloc({required this.useCase})
    : super(DepartmentDetailInitial()) {
    on<GetDepartmentDetail>(_getDepartmentDetail);
  }

  Future<void> _getDepartmentDetail(
    GetDepartmentDetail event,
    Emitter<DepartmentDetailState> emit,
  ) async {
    emit(DepartmentDetailLoading());
    try {
      final department = await useCase.callDetail(event.id);
      emit(DepartmentDetailLoaded(department));
    } catch (e) {
      emit(DepartmentDetailError(e.toString()));
    }
  }
}
