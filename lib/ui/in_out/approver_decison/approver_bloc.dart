// ui/approver/approver_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/approver_aubmission_entity.dart';
import 'package:my_app/domain/usecases/approver_use_case.dart';

// Event
abstract class ApproverEvent {}

class LoadApproverSubmission extends ApproverEvent {
  final int submissionId;
  final int deptId;
  LoadApproverSubmission({required this.submissionId, required this.deptId});
}

class DecideSubmission extends ApproverEvent {
  final int submissionId;
  final int approverId;
  final String action; // 'approved' | 'rejected'
  final String password;
  final String? comment;
  DecideSubmission({
    required this.submissionId,
    required this.approverId,
    required this.action,
    required this.password,
    this.comment,
  });
}

// State
abstract class ApproverState {}

class ApproverInitial extends ApproverState {}

class ApproverLoading extends ApproverState {}

class ApproverLoaded extends ApproverState {
  final ApproverSubmissionEntity submission;
  ApproverLoaded(this.submission);
}

class ApproverDeciding extends ApproverState {
  final ApproverSubmissionEntity submission;
  ApproverDeciding(this.submission);
}

class ApproverDecideSuccess extends ApproverState {
  final String message;
  ApproverDecideSuccess(this.message);
}

class ApproverError extends ApproverState {
  final String message;
  ApproverError(this.message);
}

class ApproverActionError extends ApproverState {
  final String message;
  final ApproverSubmissionEntity submission;
  ApproverActionError(this.message, this.submission);
}

// Bloc
class ApproverBloc extends Bloc<ApproverEvent, ApproverState> {
  final ApproverUseCase useCase;

  ApproverBloc({required this.useCase}) : super(ApproverInitial()) {
    on<LoadApproverSubmission>(_onLoad);
    on<DecideSubmission>(_onDecide);
  }

  Future<void> _onLoad(
    LoadApproverSubmission event,
    Emitter<ApproverState> emit,
  ) async {
    emit(ApproverLoading());
    try {
      final data = await useCase.getSubmission(
        event.submissionId,
        event.deptId,
      );
      emit(ApproverLoaded(data));
    } catch (e) {
      emit(ApproverError(e.toString()));
    }
  }

  Future<void> _onDecide(
    DecideSubmission event,
    Emitter<ApproverState> emit,
  ) async {
    final currentSubmission = state is ApproverLoaded
        ? (state as ApproverLoaded).submission
        : state is ApproverDeciding
        ? (state as ApproverDeciding).submission
        : state is ApproverActionError
        ? (state as ApproverActionError).submission
        : null;
    if (currentSubmission != null) {
      emit(ApproverDeciding(currentSubmission));
    } else {
      emit(ApproverLoading());
    }
    try {
      final response = await useCase.decide(
        event.submissionId,
        approverId: event.approverId,
        action: event.action,
        password: event.password,
        comment: event.comment,
      );
      if (response.success) {
        emit(ApproverDecideSuccess(response.message));
      } else {
        if (currentSubmission != null) {
          emit(ApproverActionError(response.message, currentSubmission));
        } else {
          emit(ApproverError(response.message));
        }
      }
    } catch (e) {
      if (currentSubmission != null) {
        emit(ApproverActionError(e.toString(), currentSubmission));
      } else {
        emit(ApproverError(e.toString()));
      }
    }
  }
}
