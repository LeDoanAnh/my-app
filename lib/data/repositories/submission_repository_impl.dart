import 'package:dio/dio.dart' as dio;
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/submission_response_model.dart';
import 'package:my_app/domain/entities/create_submission_params.dart';
import 'package:my_app/domain/repositories/submission_repository.dart';


class SubmissionRepositoryImpl implements SubmissionRepository {
  final AuthApi _authApi;
  SubmissionRepositoryImpl(this._authApi);

  @override
  Future<Map<String, dynamic>> createSubmission({
    required String title,
    required int workflowId,
    required String startDate,
    required String endDate,
    required int creatorId,
    String? description,
    required String departmentsJson,
    required List<FileAttachment> attachments,
  }) async {
    List<dio.MultipartFile> dioFiles = [];

    for (final f in attachments) {
      dio.MultipartFile? multipartFile;
      if (f.bytes != null) {
        multipartFile = dio.MultipartFile.fromBytes(f.bytes!, filename: f.name);
      } else if (f.path != null) {
        multipartFile = await dio.MultipartFile.fromFile(f.path!, filename: f.name);
      }
      if (multipartFile != null) {
        dioFiles.add(multipartFile);
      }
    }


    final CreateResponse response = await _authApi.createSubmission(
      title.trim(),
      workflowId,
      startDate,
      endDate,
      creatorId,
      departmentsJson,
      (description != null && description.isNotEmpty) ? description.trim() : null,
      dioFiles.isNotEmpty ? dioFiles : null,
    );

    // 3. Trả về Map<String, dynamic> để tương thích với cấu trúc cũ ở Bloc của bạn
    return {
      'success': response.success,
      'message': response.message,
    };
  }
}