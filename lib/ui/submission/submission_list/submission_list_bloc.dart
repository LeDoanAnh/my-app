import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/usecases/submission_list_use_case.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_event.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_state.dart';

class SubmissionListBloc
    extends Bloc<SubmissionListEvent, SubmissionListState> {
  final SubmissionListUseCase submissionListUseCase;

  SubmissionListBloc({required this.submissionListUseCase})
    : super(SubmissionListInitial()) {
    on<FetchSubmissionList>(_onGetSubmissionList);
  }

  Future<void> _onGetSubmissionList(
    SubmissionListEvent event,
    Emitter<SubmissionListState> emit,
  ) async {
    final int userId;
    final List<RoleEntity> roles;

    if (event is FetchSubmissionList) {
      userId = event.userId;
      roles = event.roles;
      if (state is! SubmissionListLoaded) {
        emit(SubmissionListLoading());
      }
    } else {
      return;
    }
    final hasRole3 = roles.any((role) => role.id == 3);
    final List<SubmissionEntity> mySubmission;
    final List<SubmissionEntity>? pendingApproval;
    try {
      if (hasRole3) {
        final results = await Future.wait([
          submissionListUseCase.callMySubmission(userId, 'my_submission'),
          submissionListUseCase.callPendingApproval(userId, 'pending_approval'),
        ]);
        mySubmission = results[0];
        pendingApproval = results[1];
      } else {
        mySubmission = await submissionListUseCase.callMySubmission(
          userId,
          'my_submission',
        );
        pendingApproval = [];
      }
      emit(
        SubmissionListLoaded(
          mySubmissions: mySubmission,
          pendingApproval: pendingApproval,
        ),
      );
    } catch (e) {
      emit(
        SubmissionListError(
          message: "Lỗi tải dữ liệu danh sách đơn: ${e.toString()}",
        ),
      );
    }
  }
}
