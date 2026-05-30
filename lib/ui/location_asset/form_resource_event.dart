abstract class FormResourceEvent {}

class GetDepartmentList extends FormResourceEvent {
  GetDepartmentList();
}

class SubmitCreateLocation extends FormResourceEvent {
  final String? name;
  final String? capacity;
  final String? address;
  final int? deptId;
  SubmitCreateLocation({this.name, this.capacity, this.address, this.deptId});
}

class SubmitCreateAsset extends FormResourceEvent {
  final String? name;
  final String? description;
  final String? unit;
  final String? assetType;
  final int? deptId;

  SubmitCreateAsset({
    this.name,
    this.description,
    this.unit,
    this.assetType,
    this.deptId,
  });
}
