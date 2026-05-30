import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/submission_step.dart';
import 'package:my_app/domain/usecases/submission_detail_use_case.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_event.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_state.dart';

class SubmissionDetailBloc
    extends Bloc<SubmissionDetailEvent, SubmissionDetailState> {
  final SubmissionDetailUseCase useCase;
  SubmissionDetailBloc({required this.useCase})
    : super(SubmissionDetailInitial()) {
    on<GetSubmissionDetail>(_onGetSubmissionDetail);
  }

  Future<void> _onGetSubmissionDetail(
    GetSubmissionDetail event,
    Emitter<SubmissionDetailState> emit,
  ) async {
    final int submissionId = event.submissionId;
    if (state is! SubmissionDetailLoaded) {
      emit(SubmissionDetailLoading());
    }
    try {
      final submission = await useCase.getStatistics(submissionId);
      emit(SubmissionDetailLoaded(data: submission));
    } catch (e) {
      emit(
        SubmissionDetailError(message: "Lỗi tải dữ liệu đơn: ${e.toString()}"),
      );
    }
  }
}
