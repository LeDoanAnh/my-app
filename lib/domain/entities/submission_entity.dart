class SubmissionEntity {
  final int id;
  final String? submissionCode;
  final String? title;
  final String? date;
  final String? categoryName;
  final String? status;
  final String? statusLabel;
  final String? time;
  final String? statusCode;
  final String? creatorName;
  final String? approverName;

  SubmissionEntity({
    required this.id,
    this.title,
    this.status,
    this.statusCode,
    this.time,
    this.statusLabel,
    this.creatorName,
    this.approverName,
    this.date,
    this.submissionCode,
    this.categoryName,
  });
}
