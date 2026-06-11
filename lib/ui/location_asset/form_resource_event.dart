abstract class FormResourceEvent {}

class GetDepartmentList extends FormResourceEvent {
  GetDepartmentList();
}

class SubmitCreateLocation extends FormResourceEvent {
  final int? id;
  final String? name;
  final String? capacity;
  final String? address;
  final int? deptId;
  final String status;
  SubmitCreateLocation({
    this.id,
    this.name,
    this.capacity,
    this.address,
    this.deptId,
    this.status = 'active',
  });
}

class SubmitCreateAsset extends FormResourceEvent {
  final int? id;
  final String? name;
  final String? description;
  final String? unit;
  final String? assetType;
  final int? deptId;
  final String status;

  SubmitCreateAsset({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.assetType,
    this.deptId,
    this.status = 'active',
  });
}
