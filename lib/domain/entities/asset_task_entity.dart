// domain/entities/asset_task_entity.dart
class AssetTaskEntity {
  final int id;
  final String? title;
  final String? status;
  final String? date;
  final String? sender;
  final int? itemCount;
  final ApprovedByEntity? approvedBy;
  final List<AssetTaskItemEntity>? assets;

  AssetTaskEntity({
    required this.id, this.title, this.status, this.date,
    this.sender, this.itemCount, this.approvedBy, this.assets,
  });
}

class ApprovedByEntity {
  final int? id;
  final String? name;
  final String? dept;
  final String? action;
  final String? comment;
  final String? approvedAt;

  ApprovedByEntity({this.id, this.name, this.dept, this.action, this.comment, this.approvedAt});
}

class AssetTaskItemEntity {
  final int? assetId;
  final String? assetName;
  final String? assetCode;
  final String? unit;
  final String? type;
  final String? status;
  final String? borrowDate;
  final String? expectedReturn;
  final AssetTaskBorrowerEntity? borrower;

  AssetTaskItemEntity({
    this.assetId, this.assetName, this.assetCode, this.unit,
    this.type, this.status, this.borrowDate, this.expectedReturn, this.borrower,
  });
}

class AssetTaskBorrowerEntity {
  final int? id;
  final String? name;
  final String? dept;

  AssetTaskBorrowerEntity({this.id, this.name, this.dept});
}

class AssetTaskDetailEntity {
  final int id;
  final String? title;
  final String? status;
  final String? date;
  final String? sender;
  final ApprovedByEntity? approvedBy;
  final List<AssetTaskItemEntity>? assets;

  AssetTaskDetailEntity({
    required this.id, this.title, this.status,
    this.date, this.sender, this.approvedBy, this.assets,
  });
}