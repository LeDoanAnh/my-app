import 'dart:io';

class CreateSubmissionParams {
  final String title;
  final int workflowId;
  final String startDate;
  final String endDate;
  final int creatorId;
  final String description;
  final List<dynamic> selectedItems;
  final Map<String, dynamic> contentControllers;
  final List<FileAttachment> attachments;

  CreateSubmissionParams({
    required this.title,
    required this.workflowId,
    required this.startDate,
    required this.endDate,
    required this.creatorId,
    required this.description,
    required this.selectedItems,
    required this.contentControllers,
    required this.attachments,
  });
}

class FileAttachment {
  final List<int>? bytes;
  final String? path;
  final String name;

  FileAttachment({this.bytes, this.path, required this.name});
}