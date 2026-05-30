import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/approval_step_use_case.dart';
import 'package:my_app/ui/workflow/workflow_detail/workflow_detail_event.dart';
import 'package:my_app/ui/workflow/workflow_detail/workflow_detail_state.dart';

class WorkflowDetailBloc
    extends Bloc<WorkflowDetailEvent, WorkflowDetailState> {
  final ApprovalStepUseCase useCase;

  WorkflowDetailBloc({required this.useCase}) : super(WorkDetailInitial()) {
    on<GetWorkflowDetailEvent>(_onGetWorkflowDetail);
  }

  Future<void> _onGetWorkflowDetail(
    GetWorkflowDetailEvent event,
    Emitter<WorkflowDetailState> emit,
  ) async {
    emit(WorkDetailLoading());
    try {
      final result = await useCase.getApprovalStep(event.id);
      emit(WorkDetailLoaded(result));
    } catch (e) {
      emit(WorkDetailError("Lỗi tải dữ liệu trang chủ: ${e.toString()}"));
    }
  }
}
