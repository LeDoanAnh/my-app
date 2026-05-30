import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_app/domain/entities/create_submission_params.dart';
import 'package:my_app/domain/usecases/create_submission_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_event.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final CreateSubmissionUseCase _createSubmissionUseCase;
  final DepartmentListUseCase _departmentListUseCase;

  SubmissionBloc(this._createSubmissionUseCase, this._departmentListUseCase)
    : super(SubmissionInitial()) {
    on<SubmitCreateSubmission>(_onSubmitCreateSubmission);
    on<GetDepartmentList>(_onGetDepartmentList);
  }

  Future<void> _onSubmitCreateSubmission(
    SubmitCreateSubmission event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(SubmissionDeptLoading());

    try {
      final params = CreateSubmissionParams(
        title: event.title,
        workflowId: event.workflowId,
        startDate: event.startDate,
        endDate: event.endDate,
        creatorId: event.creatorId,
        description: event.description,
        selectedItems: event.selectedItems,
        contentControllers: event.contentControllers,
        attachments: event.attachments
            .map(
              (f) => FileAttachment(name: f.name, path: f.path, bytes: f.bytes),
            )
            .toList(),
      );

      // 2. Chỉ gọi duy nhất Use Case xử lý nghiệp vụ
      final res = await _createSubmissionUseCase.call(params);

      // 3. Xử lý phản hồi trả về từ Use Case và cập nhật UI State
      if (res['success'] == true) {
        emit(
          SubmissionSubmitSuccess(
            submissionId: res['submission_id'] ?? 0,
            message: res['message'] ?? 'Tạo tờ trình thành công!',
          ),
        );
      } else {
        // Tách nhỏ lỗi validation, lỗi server nội bộ
        String msg = res['message'] ?? 'Có lỗi xảy ra.';
        final errors = res['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) msg = first.first.toString();
        }
        emit(SubmissionDeptError(msg));
      }
    } on DioException catch (e) {
      emit(
        SubmissionDeptError(
          e.response?.data?['message'] ??
              'Lỗi kết nối. Vui lòng kiểm tra mạng.',
        ),
      );
    } catch (e) {
      emit(SubmissionDeptError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGetDepartmentList(
    GetDepartmentList event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(SubmissionDeptLoading());
    try {
      final result = await _departmentListUseCase.callResources();
      emit(SubmissionDeptLoaded(result));
    } catch (e) {
      emit(SubmissionDeptError('Lỗi tải danh sách đơn vị: ${e.toString()}'));
    }
  }
}
