import 'package:file_picker/file_picker.dart';

abstract class SubmissionEvent {}

class SubmitCreateSubmission extends SubmissionEvent {
  final String title;
  final String description;
  final int workflowId;
  final int creatorId;
  final String startDate;
  final String endDate;
  final List<Map<String, dynamic>> departments;
  final List<PlatformFile> attachments;

  SubmitCreateSubmission({
    required this.title,
    required this.description,
    required this.workflowId,
    required this.creatorId,
    required this.startDate,
    required this.endDate,
    required this.departments,
    required this.attachments,
  });
}

class GetDepartmentList extends SubmissionEvent {}