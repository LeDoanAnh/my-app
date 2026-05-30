abstract class SubmissionDetailEvent {}

class GetSubmissionDetail extends SubmissionDetailEvent {
  final int submissionId;
  GetSubmissionDetail(this.submissionId);
}
