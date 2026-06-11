import 'package:my_app/domain/entities/department_entity.dart';

class AssetEntity {
  final int id;
  final int? departmentId;
  final String? assetName;
  final String? assetCode;
  final String? unit;
  final String? type;
  final String? status;
  final int? totalQuantity;
  final int? borrowedQuantity;
  final int? pendingQuantity;
  final int? availableQuantity;
  final DepartmentEntity? department;

  AssetEntity({
    required this.id,
    this.departmentId,
    this.assetName,
    this.assetCode,
    this.unit,
    this.type,
    this.status,
    this.totalQuantity,
    this.borrowedQuantity,
    this.pendingQuantity,
    this.availableQuantity,
    this.department,
  });
}
