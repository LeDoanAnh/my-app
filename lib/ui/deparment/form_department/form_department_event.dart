abstract class FormDepartmentEvent {}

class GetDepartmentList extends FormDepartmentEvent {
  GetDepartmentList();
}

class SubmitCreateDepartment extends FormDepartmentEvent {
  final String? deptName;
  final String? locationDesc;
  final int? parentDeptId;
  SubmitCreateDepartment({this.deptName, this.locationDesc, this.parentDeptId});
}
