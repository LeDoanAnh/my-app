class AssetDetailEntity {
  final int id;
  final String? assetName;
  final String? assetCode;
  final String? unit;
  final String? status;
  final String? deptName;
  final bool? isConsumable;
  final CurrentRequest? currentRequest;
  final List<History>? history;

  AssetDetailEntity({required this.id, this.assetName, this.assetCode, this.unit, this.status, this.deptName, this.isConsumable, this.currentRequest, this.history});
}

class CurrentRequest {
  final String? borrower;
  final String? handler;
  final String? borrowDate;
  final String? expectedReturn;
  final String? note;

  CurrentRequest({
    this.borrower,
    this.handler,
    this.borrowDate,
    this.expectedReturn,
    this.note,
  });
}

class History {
  final String? user;
  final String? action;
  final String? date;

  History({
    this.user,
    this.action,
    this.date,
  });
}