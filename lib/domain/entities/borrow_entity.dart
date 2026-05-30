// domain/entities/borrow_entity.dart
class BorrowEntity {
  final int submissionId;
  final String? submissionCode;
  final String? title;
  final bool isReturned;
  final bool userConfirmed;
  final bool isUrgent;
  final String? staffName;
  final List<BorrowItemEntity> items;

  BorrowEntity({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.isReturned = false,
    this.userConfirmed = true,
    this.isUrgent = false,
    this.staffName,
    this.items = const [],
  });
}

class BorrowItemEntity {
  final int? assetRequestId;
  final String? name;
  final int? qty;
  final bool isConsumable;
  final String? status;
  final String? expectedReturn;

  BorrowItemEntity({
    this.assetRequestId,
    this.name,
    this.qty,
    this.isConsumable = false,
    this.status,
    this.expectedReturn,
  });
}
