import 'package:my_app/domain/entities/department_entity.dart';

class LocationEntity {
  final int id;
  final int? departmentId;
  final String? locationName;
  final String? status;
  final String? capacity;
  final DepartmentEntity? department;

  LocationEntity({
    required this.id,
    this.departmentId,
    this.locationName,
    this.status,
    this.capacity,
    this.department,
  });
}
