import 'package:my_app/domain/entities/submission_entity.dart';

abstract class SubmissionListState {}

class SubmissionListInitial extends SubmissionListState {}

class SubmissionListLoading extends SubmissionListState {}

class SubmissionListLoaded extends SubmissionListState {
  final List<SubmissionEntity> mySubmissions;
  final List<SubmissionEntity>? pendingApproval;

  SubmissionListLoaded({required this.mySubmissions, this.pendingApproval});
}

class SubmissionListError extends SubmissionListState {
  final String message;

  SubmissionListError({required this.message});
}
