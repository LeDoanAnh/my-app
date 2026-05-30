class DepartmentStep{
  final String? deptName;
  final String? status;
  final String? time;
  final String? comment;
  final String? requestContent;

  DepartmentStep({this.deptName, this.status, this.time, this.comment, this.requestContent});
}

class SubmissionStep {
  final int id;
  final String? code;
  final String? title;
  final String? content;
  final String? status;
  final int? currentStep;
  final int? totalSteps;
  final List<DepartmentStep>? departmentSteps;
  final String? lastDeptName;


  SubmissionStep({
    required this.id,
    this.code,
    this.title,
    this.content,
    this.status,
    this.currentStep,
    this.totalSteps,
    this.departmentSteps,
    this.lastDeptName
  });
}