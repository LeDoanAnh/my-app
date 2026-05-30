class SearchResultEntity {
  final int? id;
  final String? title;
  final String? category; // submission | asset | user | department
  final String? status;
  final int? refId;

  const SearchResultEntity({
    this.id,
    this.title,
    this.category,
    this.status,
    this.refId,
  });
}
