class RecoveryEntity {
  final int submissionId;
  final String? submissionCode;
  final String? title;
  final String? borrowerName;
  final int? borrowerId;
  final bool isReturned;     // người mượn đã nhấn TRẢ ĐỒ
  final bool userConfirmed;  // người mượn đã XÁC NHẬN NHẬN ĐỒ
  final bool isUrgent;       // deadline < 24h
  final String? returnDate;  // formatted string "HH:mm - dd/MM/yyyy"
  final List<RecoveryItemEntity> items;

  RecoveryEntity({
    required this.submissionId,
    this.submissionCode,
    this.title,
    this.borrowerName,
    this.borrowerId,
    this.isReturned = false,
    this.userConfirmed = true,
    this.isUrgent = false,
    this.returnDate,
    this.items = const [],
  });
}

class RecoveryItemEntity {
  final int? assetRequestId;
  final String? name;
  final int? qty;
  final String? status;
  final String? expectedReturn;

  RecoveryItemEntity({
    this.assetRequestId,
    this.name,
    this.qty,
    this.status,
    this.expectedReturn,
  });
}