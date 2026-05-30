import 'package:json_annotation/json_annotation.dart';

part 'submission_response_model.g.dart';

@JsonSerializable()
class CreateSubmissionResponse {
  final bool success;
  final String message;

  @JsonKey(name: 'submission_id')
  final int? submissionId;

  CreateSubmissionResponse({
    required this.success,
    required this.message,
    this.submissionId,
  });

  // Hàm sinh tự động từ json_annotation
  factory CreateSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSubmissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSubmissionResponseToJson(this);
}
