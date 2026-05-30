import 'package:my_app/domain/entities/department_entity.dart';

class AssetEntity {
  final int id;
  final int? departmentId;
  final String? assetName;
  final String? assetCode;
  final String? unit;
  final String? status;
  final DepartmentEntity? department;

  AssetEntity({
    required this.id,
    this.departmentId,
    this.assetName,
    this.assetCode,
    this.unit,
    this.status,
    this.department,
  });
}
