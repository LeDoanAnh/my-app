class FileAttachment {
  final String name;
  final String? path;
  final List<int>? bytes;

  FileAttachment({required this.name, this.path, this.bytes});
}

class CreateSubmissionParams {
  final String title;
  final String description;
  final int workflowId;
  final int creatorId;
  final String startDate;
  final String endDate;
  final List<Map<String, dynamic>> departments;
  final List<FileAttachment> attachments;

  CreateSubmissionParams({
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
