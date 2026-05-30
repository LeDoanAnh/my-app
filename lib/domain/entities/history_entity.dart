class BorrowHistoryEntity {
  final int submissionId;
  final String? submissionCode;
  final String? title;
  final String? borrowerName;
  final String? receiverName;
  final String? completedDate;
  final List<HistoryItemEntity> items;

  BorrowHistoryEntity({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.borrowerName,
    this.receiverName,
    this.completedDate,
    this.items = const [],
  });
}

class HandoverHistoryEntity {
  final int id;
  final String? code;
  final String? title;
  final String? fromDept;
  final String? toDept;
  final String? handoverBy;
  final String? handoverDate;
  final List<HistoryItemEntity> items;

  HandoverHistoryEntity({
    required this.id,
    this.code,
    this.title,
    this.fromDept,
    this.toDept,
    this.handoverBy,
    this.handoverDate,
    this.items = const [],
  });
}

class HistoryItemEntity {
  final String? name;
  final int? qty;
  final bool isConsumable;

  HistoryItemEntity({
    this.name,
    this.qty,
    this.isConsumable = false,
  });
}