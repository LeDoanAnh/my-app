import 'package:my_app/domain/entities/department_entity.dart';

abstract class SubmissionState {}

class SubmissionInitial extends SubmissionState {}

// Trạng thái khi đang block UI để up dữ liệu và file vật lý lên server
class SubmissionDeptLoading extends SubmissionState {}

class SubmissionDeptLoaded extends SubmissionState {
  final List<DepartmentEntity> departments;
  SubmissionDeptLoaded(this.departments);
}

// Gửi thành công (Trả ra ID tờ trình để chuyển màn nếu cần)
class SubmissionSubmitSuccess extends SubmissionState {
  final int submissionId;
  final String message;
  SubmissionSubmitSuccess({required this.submissionId, required this.message});
}

// Gửi thất bại (Lỗi validate, lỗi mạng, lỗi server,...)
class SubmissionDeptError extends SubmissionState {
  final String message;
  SubmissionDeptError(this.message);
}
