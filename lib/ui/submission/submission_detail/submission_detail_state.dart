import 'package:my_app/domain/entities/submission_step.dart';

abstract class SubmissionDetailState {}

class SubmissionDetailInitial extends SubmissionDetailState {}

class SubmissionDetailLoading extends SubmissionDetailState {}

class SubmissionDetailLoaded extends SubmissionDetailState {
  final SubmissionStep data;
  SubmissionDetailLoaded({required this.data});
}

class SubmissionDetailError extends SubmissionDetailState {
  final String message;
  SubmissionDetailError({required this.message});
}
