import 'dart:convert' show jsonEncode;

import 'package:my_app/domain/entities/create_submission_params.dart';
import 'package:my_app/domain/repositories/submission_repository.dart';

class CreateSubmissionUseCase {
  final SubmissionRepository _repository;

  CreateSubmissionUseCase(this._repository);

  Future<Map<String, dynamic>> call(CreateSubmissionParams params) async {
    if (params.departments.isEmpty) {
      throw Exception('Vui lòng thêm ít nhất một phòng ban vào luồng duyệt.');
    }

    final String departmentsJson = jsonEncode(params.departments);

    return await _repository.createSubmission(
      title: params.title,
      workflowId: params.workflowId,
      startDate: params.startDate,
      endDate: params.endDate,
      creatorId: params.creatorId,
      description: params.description,
      departmentsJson: departmentsJson,
      attachments: params.attachments,
    );
  }
}
