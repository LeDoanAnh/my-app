abstract class FormDepartmentEvent {}

class GetDepartmentList extends FormDepartmentEvent {
  GetDepartmentList();
}

class SubmitCreateDepartment extends FormDepartmentEvent {
  final String? deptName;
  final String? locationDesc;
  final int? parentDeptId;
  final String status;
  SubmitCreateDepartment({
    this.deptName,
    this.locationDesc,
    this.parentDeptId,
    this.status = 'active',
  });
}

class SubmitUpdateDepartment extends FormDepartmentEvent {
  final int id;
  final String deptName;
  final String locationDesc;
  final int? parentDeptId;
  final String status;

  SubmitUpdateDepartment({
    required this.id,
    required this.deptName,
    required this.locationDesc,
    required this.parentDeptId,
    required this.status,
  });
}
