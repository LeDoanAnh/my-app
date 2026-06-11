import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/approval_step_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/domain/usecases/workflow_list_use_case.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_event.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_state.dart';

class CreateWorkflowBloc
    extends Bloc<CreateWorkflowEvent, CreateWorkflowState> {
  final WorkflowListUseCase workflowUseCase;
  final ApprovalStepUseCase approvalStepUseCase;
  final DepartmentListUseCase departmentUseCase;

  CreateWorkflowBloc({
    required this.workflowUseCase,
    required this.approvalStepUseCase,
    required this.departmentUseCase,
  }) : super(CreateWorkflowInitial()) {
    on<LoadCreateWorkflow>(_onLoad);
    on<SubmitCreateWorkflow>(_onSubmit);
  }

  Future<void> _onLoad(
    LoadCreateWorkflow event,
    Emitter<CreateWorkflowState> emit,
  ) async {
    emit(CreateWorkflowLoading());
    try {
      final departments = await departmentUseCase.callResources();
      final workflow = event.workflowId == null
          ? null
          : await approvalStepUseCase.getApprovalStep(event.workflowId!);

      emit(CreateWorkflowReady(departments: departments, workflow: workflow));
    } catch (e) {
      emit(CreateWorkflowError('Không tải được luồng duyệt: $e'));
    }
  }

  Future<void> _onSubmit(
    SubmitCreateWorkflow event,
    Emitter<CreateWorkflowState> emit,
  ) async {
    emit(CreateWorkflowSaving());
    try {
      final response = event.workflowId == null
          ? await workflowUseCase.createWorkflow(event.body)
          : await workflowUseCase.updateWorkflow(event.workflowId!, event.body);

      emit(CreateWorkflowSuccess(response.message));
    } catch (e) {
      emit(CreateWorkflowError('Lưu luồng duyệt thất bại: $e'));
    }
  }
}
