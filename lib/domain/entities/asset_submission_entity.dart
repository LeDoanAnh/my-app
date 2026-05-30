class AssetSubmissionEntity {
  final String id;
  final int? submissionId;
  final String? title;
  final String? date;
  final int? itemCount;
  final String? deliveryStatus;
  final String? deliveryStatusText;
  final Creator? creator;
  final List<ItemAssetSubmission>? items;

  AssetSubmissionEntity({
    required this.id,
    this.submissionId,
    this.title,
    this.date,
    this.itemCount,
    this.deliveryStatus,
    this.deliveryStatusText,
    this.creator,
    this.items,
  });
}

class Creator{
  final int? id;
  final String? name;

  Creator({
    required this.id,
    required this.name,
  });
}

class ItemAssetSubmission {
  final int? assetRequestId;
  final String? assetName;
  final String? assetCode;
  final String? expectedBorrowDate;
  final List<Creator>? creators;
  final String? status;

  ItemAssetSubmission({
    required this.assetRequestId,
    this.assetName,
    this.assetCode,
    this.expectedBorrowDate,
    this.creators,
    this.status,
  });
}
