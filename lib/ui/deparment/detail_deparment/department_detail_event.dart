abstract class DepartmentDetailEvent {}

class GetDepartmentDetail extends DepartmentDetailEvent {
  final int id;
  GetDepartmentDetail(this.id);
}
