import 'package:my_app/data/model/asset_model.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/data/model/user_model.dart';

class DepartmentEntity {
  final int id;
  final String? deptName;
  final String? locationDesc;
  final String? status;
  final int? parentDeptId;
  final int? usersCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? assetsCount;
  final int? locationsCount;
  final int? submissionsCount;
  final DepartmentModel? parent;
  final List<AssetModel>? assets;
  final List<LocationModel>? locations;
  final List<UserModel>? users;

  DepartmentEntity({
    required this.id,
    this.deptName,
    this.locationDesc,
    this.status,
    this.parentDeptId,
    this.assets,
    this.locations,
    this.usersCount,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.assetsCount,
    this.locationsCount,
    this.submissionsCount,
    this.parent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
