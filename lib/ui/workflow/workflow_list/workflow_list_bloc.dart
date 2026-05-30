import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/workflow_list_use_case.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_event.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_state.dart';

class WorkflowListBloc extends Bloc<WorkflowListEvent, WorkflowListState> {
  final WorkflowListUseCase workflowListUseCase;

  WorkflowListBloc({required this.workflowListUseCase})
    : super(WorkflowListInitial()) {
    on<GetWorkflowList>(_getWorkflowList);
  }

  Future<void> _getWorkflowList(
    GetWorkflowList event,
    Emitter<WorkflowListState> emit,
  ) async {
    emit(WorkflowListLoading());
    try {
      final workflows = await workflowListUseCase.callWorkflowList();
      emit(WorkflowListLoaded(workflows));
    } catch (e) {
      emit(WorkflowListError(e.toString()));
    }
  }
}
